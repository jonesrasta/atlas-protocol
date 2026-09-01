// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {TreasuryBaseTest} from "./TreasuryBase.t.sol";

import {TreasuryErrors} from "../../../src/treasury/TreasuryErrors.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract TreasuryWithdrawETHTest is TreasuryBaseTest {
    uint256 internal constant WITHDRAW_AMOUNT = 25 ether;

    event ETHWithdrawn(address indexed receiver, uint256 amount);

    function setUp() public override {
        super.setUp();

        _fundTreasuryETH(INITIAL_ETH_BALANCE);
    }

    // =============================================================
    //                         SUCCESS
    // =============================================================

    function test_withdrawETH_transfersETH() public {
        uint256 balanceBefore = payable(receiver).balance;

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);

        assertEq(payable(receiver).balance, balanceBefore + WITHDRAW_AMOUNT);

        assertEq(treasury.balanceETH(), INITIAL_ETH_BALANCE - WITHDRAW_AMOUNT);
    }

    function test_withdrawETH_emitsEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHWithdrawn(receiver, WITHDRAW_AMOUNT);

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);
    }

    function test_withdrawETH_managerCanWithdrawEntireBalance() public {
        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), INITIAL_ETH_BALANCE);

        assertEq(treasury.balanceETH(), 0);
        assertEq(receiver.balance, INITIAL_ETH_BALANCE * 2);
    }

    function test_withdrawETH_multipleWithdrawalsReduceBalance() public {
        vm.startPrank(manager);

        treasury.withdrawETH(payable(receiver), 10 ether);

        treasury.withdrawETH(payable(receiver), 20 ether);

        vm.stopPrank();

        assertEq(treasury.balanceETH(), 70 ether);
    }

    // =============================================================
    //                         ACCESS CONTROL
    // =============================================================

    function test_withdrawETH_revertsWithoutManagerRole() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        treasury.withdrawETH(payable(receiver), WITHDRAW_AMOUNT);
    }

    // =============================================================
    //                         VALIDATION
    // =============================================================

    function test_withdrawETH_revertsWhenReceiverIsZeroAddress() public {
        vm.expectRevert(TreasuryErrors.ZeroAddress.selector);

        vm.prank(manager);

        treasury.withdrawETH(payable(address(0)), WITHDRAW_AMOUNT);
    }

    function test_withdrawETH_revertsWhenAmountIsZero() public {
        vm.expectRevert(TreasuryErrors.InvalidAmount.selector);

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), 0);
    }

    function test_withdrawETH_revertsWhenAmountExceedsBalance() public {
        vm.expectRevert(TreasuryErrors.InsufficientBalance.selector);

        vm.prank(manager);

        treasury.withdrawETH(payable(receiver), INITIAL_ETH_BALANCE + 1 ether);
    }

    // =============================================================
    //                         TRANSFER
    // =============================================================

    function test_withdrawETH_revertsWhenTransferFails() public {
        RejectETHReceiver rejectReceiver = new RejectETHReceiver();

        vm.expectRevert(TreasuryErrors.TransferFailed.selector);

        vm.prank(manager);

        treasury.withdrawETH(payable(address(rejectReceiver)), 1 ether);
    }
}

contract RejectETHReceiver {
    receive() external payable {
        revert();
    }
}

