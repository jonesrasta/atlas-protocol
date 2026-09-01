// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AtlasVault} from "../../../src/vault/AtlasVault.sol";
import {AtlasToken} from "../../../src/token/AtlasToken.sol";

contract VaultHandler is Test {
    // =============================================================
    //                           STATE
    // =============================================================

    AtlasVault internal immutable vault;
    AtlasToken internal immutable asset;
    address internal immutable admin;
    address[] internal actors;

    // =============================================================
    //                         GHOST STATE
    // =============================================================

    /// @notice Total assets deposited through normal deposits.
    uint256 public ghostDeposited;

    /// @notice Total assets withdrawn/redeemed through normal operations.
    uint256 public ghostWithdrawn;

    /// @notice Total assets directly donated through normal operations.
    uint256 public ghostDonated;

    /// @notice Total shares minted through normal deposits.
    uint256 public ghostSharesMinted;

    /// @notice Total shares burned through normal withdrawals/redeems.
    uint256 public ghostSharesBurned;

    // =============================================================
    //                    INFLATION ATTACK GHOSTS
    // =============================================================

    /// @notice Whether the isolated inflation attack was executed.
    bool public ghostAttackExecuted;

    /// @notice Initial attacker deposit.
    uint256 public ghostAttackerCapital;

    /// @notice Assets directly donated by the attacker.
    uint256 public ghostAttackerDonation;

    /// @notice Assets recovered by the attacker.
    uint256 public ghostAttackerRecovered;

    /// @notice Assets deposited by the victim.
    uint256 public ghostVictimDeposited;

    /// @notice Shares received by the victim.
    uint256 public ghostVictimShares;

    // =============================================================
    //                       CONSTRUCTOR
    // =============================================================

    constructor(AtlasVault _vault, AtlasToken _asset, address _admin) {
        vault = _vault;
        asset = _asset;
        admin = _admin;

        actors.push(makeAddr("invariant-user-1"));
        actors.push(makeAddr("invariant-user-2"));
        actors.push(makeAddr("invariant-user-3"));
    }

    // =============================================================
    //                           HANDLER
    // =============================================================

    /// @notice Deposits assets on behalf of a bounded actor.
    function deposit(uint256 actorSeed, uint256 amount) external {
        address depositor = _actor(actorSeed);

        amount = bound(amount, 1, 1_000 ether);

        // Ignore deposits that would mint zero shares.
        if (vault.previewDeposit(amount) == 0) {
            return;
        }

        _mintAsset(depositor, amount);

        vm.startPrank(depositor);

        asset.approve(address(vault), amount);

        uint256 sharesBefore = vault.balanceOf(depositor);
        uint256 shares = vault.deposit(amount, depositor);
        uint256 sharesAfter = vault.balanceOf(depositor);

        vm.stopPrank();

        assertGt(shares, 0);
        assertEq(sharesAfter - sharesBefore, shares);

        ghostDeposited += amount;
        ghostSharesMinted += shares;
    }

    /// @notice Withdraws assets from a bounded actor.
    function withdraw(uint256 actorSeed, uint256 amount) external {
        address withdrawer = _actor(actorSeed);

        uint256 sharesBefore = vault.balanceOf(withdrawer);

        if (sharesBefore == 0) {
            return;
        }

        uint256 maxAssets = vault.convertToAssets(sharesBefore);

        if (maxAssets == 0) {
            return;
        }

        amount = bound(amount, 1, maxAssets);

        uint256 expectedShares = vault.previewWithdraw(amount);

        if (expectedShares == 0 || expectedShares > sharesBefore) {
            return;
        }

        vm.prank(withdrawer);

        uint256 sharesBurned = vault.withdraw(amount, withdrawer, withdrawer);

        uint256 sharesAfter = vault.balanceOf(withdrawer);

        assertGt(sharesBurned, 0);
        assertEq(sharesBefore - sharesAfter, sharesBurned);

        ghostWithdrawn += amount;
        ghostSharesBurned += sharesBurned;
    }

    /// @notice Redeems a bounded amount of shares.
    function redeem(uint256 actorSeed, uint256 shares) external {
        address redeemer = _actor(actorSeed);

        uint256 sharesBefore = vault.balanceOf(redeemer);

        if (sharesBefore == 0) {
            return;
        }

        shares = bound(shares, 1, sharesBefore);

        uint256 expectedAssets = vault.previewRedeem(shares);

        if (expectedAssets == 0) {
            return;
        }

        vm.prank(redeemer);

        uint256 assetsReceived = vault.redeem(shares, redeemer, redeemer);

        uint256 sharesAfter = vault.balanceOf(redeemer);

        assertGt(assetsReceived, 0);
        assertEq(sharesBefore - sharesAfter, shares);

        ghostWithdrawn += assetsReceived;
        ghostSharesBurned += shares;
    }

    /// @notice Directly donates assets without minting shares.
    function donate(uint256 amount) external {
        amount = bound(amount, 1, 1_000 ether);

        _mintAsset(address(this), amount);

        uint256 sharesBefore = vault.totalSupply();
        uint256 assetsBefore = vault.totalAssets();

        vm.prank(address(this));

        bool success = asset.transfer(address(vault), amount);

        assertTrue(success);

        uint256 sharesAfter = vault.totalSupply();
        uint256 assetsAfter = vault.totalAssets();

        // Donation must not mint shares.
        assertEq(sharesAfter, sharesBefore);

        // Vault must receive the donated assets.
        assertEq(assetsAfter, assetsBefore + amount);

        ghostDonated += amount;
    }

    // =============================================================
    //                    INFLATION ATTACK
    // =============================================================

    /// @notice Executes one isolated ERC-4626 inflation attack.
    ///
    /// Scenario:
    ///
    /// 1. Attacker deposits initial capital.
    /// 2. Attacker donates assets directly to the vault.
    /// 3. Victim deposits assets.
    /// 4. Attacker redeems all shares.
    ///
    /// The attack starts only from an empty vault and is executed
    /// once so the economic measurement remains isolated.
    function inflationAttack(uint256 attackerDeposit, uint256 attackerDonation, uint256 victimDeposit) external {
        if (ghostAttackExecuted) {
            return;
        }

        // The attack must start from a completely empty vault.
        if (vault.totalSupply() != 0 || vault.totalAssets() != 0) {
            return;
        }

        attackerDeposit = bound(attackerDeposit, 1, 1 ether);

        attackerDonation = bound(attackerDonation, 1, 1_000 ether);

        victimDeposit = bound(victimDeposit, 1, 1_000 ether);

        address attacker = actors[0];
        address victim = actors[1];

        // ---------------------------------------------------------
        // 1. Attacker deposit
        // ---------------------------------------------------------

        _mintAsset(attacker, attackerDeposit);

        vm.startPrank(attacker);

        asset.approve(address(vault), attackerDeposit);

        uint256 attackerShares = vault.deposit(attackerDeposit, attacker);

        vm.stopPrank();

        if (attackerShares == 0) {
            return;
        }

        // ---------------------------------------------------------
        // 2. Attacker donation
        // ---------------------------------------------------------

        _mintAsset(attacker, attackerDonation);

        uint256 assetsBeforeDonation = vault.totalAssets();

        vm.prank(attacker);

        bool donationSuccess = asset.transfer(address(vault), attackerDonation);

        assertTrue(donationSuccess);

        assertEq(vault.totalAssets(), assetsBeforeDonation + attackerDonation);

        // Donation must not mint shares.
        assertEq(vault.totalSupply(), attackerShares);

        // ---------------------------------------------------------
        // 3. Victim deposit
        // ---------------------------------------------------------

        _mintAsset(victim, victimDeposit);

        uint256 victimSharesBefore = vault.balanceOf(victim);

        vm.startPrank(victim);

        asset.approve(address(vault), victimDeposit);

        uint256 victimShares = vault.deposit(victimDeposit, victim);

        vm.stopPrank();

        uint256 victimSharesAfter = vault.balanceOf(victim);

        assertEq(victimSharesAfter - victimSharesBefore, victimShares);

        // ---------------------------------------------------------
        // 4. Attacker redeems all shares
        // ---------------------------------------------------------

        uint256 attackerAssetsBefore = asset.balanceOf(attacker);

        vm.prank(attacker);

        uint256 attackerRecovered = vault.redeem(attackerShares, attacker, attacker);

        uint256 attackerAssetsAfter = asset.balanceOf(attacker);

        assertEq(attackerAssetsAfter - attackerAssetsBefore, attackerRecovered);

        // Attacker must have no shares left.
        assertEq(vault.balanceOf(attacker), 0);

        // ---------------------------------------------------------
        // Record economic state
        // ---------------------------------------------------------

        ghostAttackExecuted = true;

        ghostAttackerCapital = attackerDeposit;
        ghostAttackerDonation = attackerDonation;
        ghostAttackerRecovered = attackerRecovered;

        ghostVictimDeposited = victimDeposit;
        ghostVictimShares = victimShares;
    }

    // =============================================================
    //                         INTERNAL
    // =============================================================

    function _actor(uint256 seed) internal view returns (address) {
        return actors[seed % actors.length];
    }

    function _mintAsset(address to, uint256 amount) internal {
        vm.prank(admin);
        asset.mint(to, amount);
    }

    // =============================================================
    //                          GETTERS
    // =============================================================

    function actor(uint256 index) external view returns (address) {
        return actors[index % actors.length];
    }

    function actorCount() external view returns (uint256) {
        return actors.length;
    }
}

