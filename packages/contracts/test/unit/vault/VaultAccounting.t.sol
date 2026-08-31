// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";

contract VaultAccountingTest is VaultBase {
    uint256 internal constant AMOUNT = 100 ether;

    function setUp() public override {
        super.setUp();

        mintAsset(user, AMOUNT);

        vm.startPrank(user);

        asset.approve(address(vault), AMOUNT);
        vault.deposit(AMOUNT, user);

        vm.stopPrank();
    }

    // =============================================================
    //                         ACCOUNTING
    // =============================================================

    function test_totalAssets_matchesDeposits() public view {
        assertEq(vault.totalAssets(), AMOUNT);
    }

    function test_totalSupply_matchesShares() public view {
        assertEq(vault.totalSupply(), AMOUNT);
    }

    function test_userShares_matchesDeposit() public view {
        assertEq(vault.balanceOf(user), AMOUNT);
    }

    function test_userAssets_areTransferredToVault() public view {
        assertEq(asset.balanceOf(user), 0);
        assertEq(asset.balanceOf(address(vault)), AMOUNT);
    }

    // =============================================================
    //                       CONVERSIONS
    // =============================================================

    function test_convertToShares() public view {
        uint256 shares = vault.convertToShares(AMOUNT);

        assertEq(shares, AMOUNT);
    }

    function test_convertToAssets() public view {
        uint256 assets = vault.convertToAssets(AMOUNT);

        assertEq(assets, AMOUNT);
    }

    function test_previewDeposit() public view {
        uint256 shares = vault.previewDeposit(AMOUNT);

        assertEq(shares, AMOUNT);
    }

    function test_previewMint() public view {
        uint256 assets = vault.previewMint(AMOUNT);

        assertEq(assets, AMOUNT);
    }

    function test_previewWithdraw() public view {
        uint256 shares = vault.previewWithdraw(AMOUNT);

        assertEq(shares, AMOUNT);
    }

    function test_previewRedeem() public view {
        uint256 assets = vault.previewRedeem(AMOUNT);

        assertEq(assets, AMOUNT);
    }

    // =============================================================
    //                     ROUND TRIP: REDEEM
    // =============================================================

    function test_redeem_restoresAssetsAndClearsShares() public {
        uint256 userSharesBefore = vault.balanceOf(user);
        uint256 userAssetsBefore = asset.balanceOf(user);

        vm.prank(user);

        uint256 assetsReceived = vault.redeem(userSharesBefore, user, user);

        assertEq(assetsReceived, AMOUNT);

        assertEq(vault.balanceOf(user), 0);
        assertEq(vault.totalSupply(), 0);

        assertEq(asset.balanceOf(user), userAssetsBefore + AMOUNT);
        assertEq(vault.totalAssets(), 0);
    }

    // =============================================================
    //                    ROUND TRIP: WITHDRAW
    // =============================================================

    function test_withdraw_restoresAssetsAndClearsShares() public {
        vm.prank(user);

        uint256 sharesBurned = vault.withdraw(AMOUNT, user, user);

        assertEq(sharesBurned, AMOUNT);

        assertEq(vault.balanceOf(user), 0);
        assertEq(vault.totalSupply(), 0);

        assertEq(asset.balanceOf(user), AMOUNT);
        assertEq(vault.totalAssets(), 0);
    }

    // =============================================================
    //                    MULTIPLE DEPOSITORS
    // =============================================================

    function test_multipleDepositors_preserveAccounting() public {
        mintAsset(user2, AMOUNT);

        vm.startPrank(user2);

        asset.approve(address(vault), AMOUNT);

        uint256 shares = vault.deposit(AMOUNT, user2);

        vm.stopPrank();

        assertEq(shares, AMOUNT);

        assertEq(vault.totalAssets(), AMOUNT * 2);
        assertEq(vault.totalSupply(), AMOUNT * 2);

        assertEq(vault.balanceOf(user), AMOUNT);
        assertEq(vault.balanceOf(user2), AMOUNT);
    }

    function test_firstDepositor_redeemDoesNotAffectSecondDepositor() public {
        mintAsset(user2, AMOUNT);

        vm.startPrank(user2);

        asset.approve(address(vault), AMOUNT);
        vault.deposit(AMOUNT, user2);

        vm.stopPrank();

        vm.prank(user);

        uint256 assetsReceived = vault.redeem(AMOUNT, user, user);

        assertEq(assetsReceived, AMOUNT);

        assertEq(vault.balanceOf(user), 0);
        assertEq(vault.balanceOf(user2), AMOUNT);

        assertEq(vault.totalSupply(), AMOUNT);
        assertEq(vault.totalAssets(), AMOUNT);

        assertEq(asset.balanceOf(user), AMOUNT);
        assertEq(asset.balanceOf(user2), 0);
    }

    // =============================================================
    //                  SHARE / ASSET CONSISTENCY
    // =============================================================

    function test_sharesAndAssetsRemainConsistent() public view {
        uint256 shares = vault.balanceOf(user);
        uint256 assets = vault.convertToAssets(shares);

        assertEq(assets, AMOUNT);
    }

    function test_assetsAndSharesRemainConsistent() public view {
        uint256 assets = vault.totalAssets();
        uint256 shares = vault.convertToShares(assets);

        assertEq(shares, vault.totalSupply());
    }

    // =============================================================
    //                    DONATION / EXCHANGE RATE
    // =============================================================

    function test_donation_increasesExchangeRate() public {
        uint256 donation = AMOUNT;

        mintAsset(address(vault), donation);

        assertEq(vault.totalAssets(), AMOUNT + donation);
        assertEq(vault.totalSupply(), AMOUNT);

        uint256 assetsPerShare = vault.convertToAssets(1 ether);

        assertGt(assetsPerShare, 1 ether);
        assertLt(assetsPerShare, 2 ether);
    }

    function test_donation_reducesSharesReceivedByNextDepositor() public {
        uint256 donation = AMOUNT;

        // Vault começa com:
        // 100 assets / 100 shares.
        //
        // Uma doação direta adiciona 100 assets sem criar shares.
        mintAsset(address(vault), donation);

        assertEq(vault.totalAssets(), AMOUNT * 2);
        assertEq(vault.totalSupply(), AMOUNT);

        // O segundo usuário deposita 100 assets.
        mintAsset(user2, AMOUNT);

        vm.startPrank(user2);

        asset.approve(address(vault), AMOUNT);

        uint256 sharesReceived = vault.deposit(AMOUNT, user2);

        vm.stopPrank();

        // Exchange rate estava aproximadamente em 2 assets/share,
        // portanto 100 assets devem gerar aproximadamente 50 shares.
        assertEq(sharesReceived, 50 ether);

        assertEq(vault.balanceOf(user2), 50 ether);
        assertEq(vault.totalSupply(), 150 ether);
        assertEq(vault.totalAssets(), 300 ether);
    }

    function test_donation_doesNotMintShares() public {
        uint256 supplyBefore = vault.totalSupply();
        uint256 assetsBefore = vault.totalAssets();

        mintAsset(address(vault), AMOUNT);

        assertEq(vault.totalSupply(), supplyBefore);
        assertEq(vault.totalAssets(), assetsBefore + AMOUNT);
    }

    // =============================================================
    //                    EXCHANGE RATE
    // =============================================================

    function test_exchangeRate_changesAfterDonation() public {
        uint256 sharesBefore = vault.totalSupply();
        uint256 assetsBefore = vault.totalAssets();

        mintAsset(address(vault), AMOUNT);

        uint256 sharesAfter = vault.totalSupply();
        uint256 assetsAfter = vault.totalAssets();

        assertEq(sharesAfter, sharesBefore);
        assertEq(assetsAfter, assetsBefore + AMOUNT);

        uint256 convertedAssets = vault.convertToAssets(AMOUNT);

        assertGt(convertedAssets, AMOUNT);
        assertLt(convertedAssets, 2 * AMOUNT);
    }

    // =============================================================
    //                         ROUNDING
    // =============================================================

    function test_deposit_roundsSharesDown() public {
        // Vault:
        // 100 assets / 100 shares
        //
        // Donation:
        // +1 asset
        //
        // New exchange rate:
        // 101 assets / 100 shares

        mintAsset(address(vault), 1 ether);

        uint256 previewedShares = vault.previewDeposit(1);

        // Deposit de 1 wei deve arredondar para baixo.
        assertEq(previewedShares, 0);

        mintAsset(user2, 1);

        vm.startPrank(user2);

        asset.approve(address(vault), 1);

        uint256 sharesReceived = vault.deposit(1, user2);

        vm.stopPrank();

        assertEq(sharesReceived, 0);
        assertEq(vault.balanceOf(user2), 0);
    }

    function test_mint_roundsAssetsUp() public {
        mintAsset(address(vault), 1 ether);

        uint256 previewedAssets = vault.previewMint(1);

        // Mint de 1 wei de share exige 2 wei de asset.
        assertEq(previewedAssets, 2);

        mintAsset(user2, 2);

        vm.startPrank(user2);

        asset.approve(address(vault), 2);

        uint256 assetsSpent = vault.mint(1, user2);

        vm.stopPrank();

        assertEq(assetsSpent, 2);
        assertEq(vault.balanceOf(user2), 1);
    }

    function test_withdraw_roundsSharesUp() public {
        mintAsset(address(vault), 1 ether);

        uint256 previewedShares = vault.previewWithdraw(1);

        assertEq(previewedShares, 1);

        uint256 sharesBefore = vault.balanceOf(user);

        vm.prank(user);

        uint256 sharesBurned = vault.withdraw(1, user, user);

        assertEq(sharesBurned, 1);
        assertEq(vault.balanceOf(user), sharesBefore - 1);
        assertEq(asset.balanceOf(user), 1);
    }

    function test_redeem_roundsAssetsDown() public {
        mintAsset(address(vault), 1 ether);

        uint256 previewedAssets = vault.previewRedeem(1);

        assertEq(previewedAssets, 1);

        uint256 sharesBefore = vault.balanceOf(user);

        vm.prank(user);

        uint256 assetsReceived = vault.redeem(1, user, user);

        assertEq(assetsReceived, 1);
        assertEq(vault.balanceOf(user), sharesBefore - 1);
        assertEq(asset.balanceOf(user), 1);
    }
}
