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

    function test_totalAssets_matchesDeposits() public view {
        assertEq(vault.totalAssets(), AMOUNT);
    }

    function test_totalSupply_matchesShares() public view {
        assertEq(vault.totalSupply(), AMOUNT);
    }

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
}
