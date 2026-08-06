// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";
import {AccessManager} from "../../../src/access/AccessManager.sol";

import {Roles} from "../../../src/access/Roles.sol";
import {TreasuryErrors} from "../../../src/treasury/TreasuryErrors.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract TreasuryWithdrawETHTest is Test {
    Treasury treasury;
    AccessManager accessManager;

    address admin = address(1);
    address manager = address(2);
    address receiver = address(3);
    address user = address(4);

    uint256 constant INITIAL_BALANCE = 100 ether;
    uint256 constant WITHDRAW_AMOUNT = 25 ether;

    function setUp() public {
        vm.startPrank(admin);

        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, manager);

        vm.stopPrank();

        vm.deal(address(treasury), INITIAL_BALANCE);
    }

    function test_WithdrawETH() public {
        uint256 receiverBefore = receiver.balance;

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);

        assertEq(receiver.balance, receiverBefore + WITHDRAW_AMOUNT);

        assertEq(treasury.balanceETH(), INITIAL_BALANCE - WITHDRAW_AMOUNT);
    }

    function test_EmitETHWithdrawnEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHWithdrawn(receiver, WITHDRAW_AMOUNT);

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_UserWithoutRoleWithdrawsETH() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_WithdrawAmountExceedsBalance() public {
        vm.expectRevert(TreasuryErrors.InsufficientBalance.selector);

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), INITIAL_BALANCE + 1 ether);
    }

    function test_RevertWhen_ReceiverIsZeroAddress() public {
        vm.expectRevert();

        vm.prank(manager);

        treasury.withdrawETH(payable(address(0)), WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_AmountIsZero() public {
        vm.expectRevert();

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), 0);
    }

    function test_ManagerCanWithdrawEntireTreasuryBalance() public {
        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), INITIAL_BALANCE);

        assertEq(treasury.balanceETH(), 0);

        assertEq(receiver.balance, INITIAL_BALANCE);
    }

    function test_MultipleWithdrawalsReduceBalance() public {
        vm.startPrank(manager);

        treasury.withdrawETH(payable(receiver), 10 ether);

        treasury.withdrawETH(payable(receiver), 20 ether);

        vm.stopPrank();

        assertEq(treasury.balanceETH(), 70 ether);
    }

    event ETHWithdrawn(address indexed receiver, uint256 amount);
}
