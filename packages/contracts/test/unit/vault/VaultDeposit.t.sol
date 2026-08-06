// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {VaultEvents} from "../../../src/vault/VaultEvents.sol";

contract VaultDepositTest is VaultBase, VaultEvents {
    uint256 internal constant DEPOSIT_AMOUNT = 100 ether;

    function setUp() public override {
        super.setUp();

        mintAsset(user, DEPOSIT_AMOUNT);
    }

    function test_deposit_mintsShares() public {
        vm.startPrank(user);

        asset.approve(address(vault), DEPOSIT_AMOUNT);

        uint256 shares = vault.deposit(DEPOSIT_AMOUNT, user);

        vm.stopPrank();

        assertEq(shares, DEPOSIT_AMOUNT);

        assertEq(vault.balanceOf(user), DEPOSIT_AMOUNT);

        assertEq(vault.totalAssets(), DEPOSIT_AMOUNT);
    }

    function test_deposit_emitsEvent() public {
        vm.startPrank(user);

        asset.approve(address(vault), DEPOSIT_AMOUNT);

        vm.expectEmit(true, true, false, true);

        emit Deposited(user, user, DEPOSIT_AMOUNT, DEPOSIT_AMOUNT);

        vault.deposit(DEPOSIT_AMOUNT, user);

        vm.stopPrank();
    }

    function test_deposit_revertsWhenPaused() public {
        vm.prank(admin);

        vault.pause();

        vm.startPrank(user);

        asset.approve(address(vault), DEPOSIT_AMOUNT);

        vm.expectRevert();

        vault.deposit(DEPOSIT_AMOUNT, user);

        vm.stopPrank();
    }
}
