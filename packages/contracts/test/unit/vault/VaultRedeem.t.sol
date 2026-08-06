// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {VaultEvents} from "../../../src/vault/VaultEvents.sol";

contract VaultRedeemTest is VaultBase, VaultEvents {
    uint256 internal constant DEPOSIT_AMOUNT = 100 ether;

    function setUp() public override {
        super.setUp();

        mintAsset(user, DEPOSIT_AMOUNT);

        vm.startPrank(user);

        asset.approve(address(vault), DEPOSIT_AMOUNT);

        vault.deposit(DEPOSIT_AMOUNT, user);

        vm.stopPrank();
    }

    function test_redeem_returnsAssets() public {
        vm.prank(user);

        uint256 assets = vault.redeem(DEPOSIT_AMOUNT, user, user);

        assertEq(assets, DEPOSIT_AMOUNT);

        assertEq(asset.balanceOf(user), DEPOSIT_AMOUNT);

        assertEq(vault.balanceOf(user), 0);

        assertEq(vault.totalAssets(), 0);
    }

    function test_redeem_emitsEvent() public {
        vm.prank(user);

        vm.expectEmit(true, true, true, true);

        emit Redeemed(user, user, user, DEPOSIT_AMOUNT, DEPOSIT_AMOUNT);

        vault.redeem(DEPOSIT_AMOUNT, user, user);
    }

    function test_redeem_revertsWhenPaused() public {
        vm.prank(admin);

        vault.pause();

        vm.prank(user);

        vm.expectRevert();

        vault.redeem(DEPOSIT_AMOUNT, user, user);
    }
}
