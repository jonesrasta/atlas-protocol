// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {AtlasToken} from "../../../src/token/AtlasToken.sol";
import {AtlasVault} from "../../../src/vault/AtlasVault.sol";
import {VaultHandler} from "./VaultHandler.sol";

contract VaultInvariantTest is Test {
    // =============================================================
    //                           STATE
    // =============================================================

    AtlasToken internal asset;
    AtlasVault internal vault;
    AccessManager internal accessManager;
    VaultHandler internal handler;

    address internal admin = makeAddr("admin");

    // =============================================================
    //                           SETUP
    // =============================================================

    function setUp() public {
        accessManager = new AccessManager(admin);

        asset = new AtlasToken(address(accessManager));

        vault = new AtlasVault(asset, address(accessManager));

        vm.startPrank(admin);

        accessManager.grantRole(keccak256("PROTOCOL_ADMIN_ROLE"), admin);

        accessManager.grantRole(keccak256("MINTER_ROLE"), admin);

        vm.stopPrank();

        handler = new VaultHandler(vault, asset, admin);

        targetContract(address(handler));
    }

    // =============================================================
    //                         ACCOUNTING
    // =============================================================

    /// @notice Vault accounting must always match the actual ERC20
    ///         balance held by the vault.
    function invariant_vaultAssetsMatchTokenBalance() public view {
        assertEq(vault.totalAssets(), asset.balanceOf(address(vault)));
    }

    /// @notice The value represented by all shares cannot exceed
    ///         the assets held by the vault.
    function invariant_totalShareValueCannotExceedAssets() public view {
        uint256 totalAssets = vault.totalAssets();
        uint256 totalShares = vault.totalSupply();

        if (totalShares == 0) {
            return;
        }

        uint256 shareValue = vault.convertToAssets(totalShares);

        assertLe(shareValue, totalAssets);
    }

    /// @notice Converting the complete vault asset balance to shares
    ///         cannot produce more shares than currently exist.
    function invariant_convertToSharesCannotExceedSupply() public view {
        uint256 totalAssets = vault.totalAssets();
        uint256 totalShares = vault.totalSupply();

        if (totalAssets == 0 || totalShares == 0) {
            return;
        }

        uint256 convertedShares = vault.convertToShares(totalAssets);

        assertLe(convertedShares, totalShares);
    }

    // =============================================================
    //                           SUPPLY
    // =============================================================

    /// @notice If total supply is zero, no tracked actor can own shares.
    function invariant_zeroSupplyMeansZeroShares() public view {
        if (vault.totalSupply() != 0) {
            return;
        }

        assertEq(vault.balanceOf(handler.actor(0)), 0);

        assertEq(vault.balanceOf(handler.actor(1)), 0);

        assertEq(vault.balanceOf(handler.actor(2)), 0);
    }

    /// @notice When shares exist, one share must have non-zero value.
    function invariant_exchangeRateIsPositiveWhenSharesExist() public view {
        if (vault.totalSupply() == 0) {
            return;
        }

        assertGt(vault.convertToAssets(1), 0);
    }

    /// @notice All shares held by tracked actors must equal total supply.
    function invariant_totalUserSharesEqualSupply() public view {
        uint256 userShares =
            vault.balanceOf(handler.actor(0)) + vault.balanceOf(handler.actor(1)) + vault.balanceOf(handler.actor(2));

        assertEq(userShares, vault.totalSupply());
    }

    // =============================================================
    //                     ECONOMIC CONSERVATION
    // =============================================================

    /// @notice Every asset entering or leaving the vault through the
    ///         handler must be reflected in vault.totalAssets().
    function invariant_assetConservation() public view {
        uint256 normalInflow = handler.ghostDeposited() + handler.ghostDonated();

        uint256 normalOutflow = handler.ghostWithdrawn();

        uint256 attackInflow =
            handler.ghostAttackerCapital() + handler.ghostAttackerDonation() + handler.ghostVictimDeposited();

        uint256 attackOutflow = handler.ghostAttackerRecovered();

        uint256 totalInflow = normalInflow + attackInflow;

        uint256 totalOutflow = normalOutflow + attackOutflow;

        assertGe(totalInflow, totalOutflow);

        assertEq(vault.totalAssets(), totalInflow - totalOutflow);
    }

    // =============================================================
    //                    INFLATION ATTACK
    // =============================================================

    /// @notice The attacker cannot recover more assets than the
    ///         capital committed to the attack.
    ///
    /// Attacker capital:
    ///
    ///     initial deposit + donation
    ///
    /// The victim deposit is not attacker capital.
    function invariant_inflationAttackAttackerCannotProfitFromNothing() public view {
        if (!handler.ghostAttackExecuted()) {
            return;
        }

        uint256 attackerCapital = handler.ghostAttackerCapital() + handler.ghostAttackerDonation();

        assertLe(handler.ghostAttackerRecovered(), attackerCapital);
    }
}
