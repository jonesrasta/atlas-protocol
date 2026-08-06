// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {VaultEvents} from "../../../src/vault/VaultEvents.sol";

contract VaultWithdrawTest is VaultBase, VaultEvents {
    uint256 internal constant DEPOSIT_AMOUNT = 100 ether;

    function setUp() public override {
        super.setUp();

        mintAsset(user, DEPOSIT_AMOUNT);

        vm.startPrank(user);

        asset.approve(address(vault), DEPOSIT_AMOUNT);

        vault.deposit(DEPOSIT_AMOUNT, user);

        vm.stopPrank();
    }

    function test_withdraw_redeemsAssets() public {
        vm.prank(user);

        uint256 shares = vault.withdraw(DEPOSIT_AMOUNT, user, user);

        assertEq(shares, DEPOSIT_AMOUNT);

        assertEq(asset.balanceOf(user), DEPOSIT_AMOUNT);

        assertEq(vault.totalAssets(), 0);

        assertEq(vault.balanceOf(user), 0);
    }

    function test_withdraw_emitsEvent() public {
        vm.prank(user);

        vm.expectEmit(true, true, true, true);

        emit Withdrawn(user, user, user, DEPOSIT_AMOUNT, DEPOSIT_AMOUNT);

        vault.withdraw(DEPOSIT_AMOUNT, user, user);
    }

    function test_withdraw_revertsWhenPaused() public {
        vm.prank(admin);

        vault.pause();

        vm.prank(user);

        vm.expectRevert();

        vault.withdraw(DEPOSIT_AMOUNT, user, user);
    }
}
