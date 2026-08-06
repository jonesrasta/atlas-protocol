// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {TreasuryBaseTest} from "./TreasuryBase.t.sol";

/// @title TreasuryDepositETHTest
/// @author Atlas Protocol
/// @notice Testes de depósito de ETH no Treasury.
contract TreasuryDepositETHTest is TreasuryBaseTest {
    uint256 internal constant DEPOSIT_AMOUNT = 10 ether;

    function testDepositETHSuccess() public {
        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(treasury.balanceETH(), DEPOSIT_AMOUNT);

        assertEq(address(treasury).balance, DEPOSIT_AMOUNT);
    }

    function testDepositETHUpdatesTreasuryBalance() public {
        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(treasury.balanceETH(), address(treasury).balance);
    }

    function testMultipleETHDeposits() public {
        _depositETH(user, 5 ether);

        _depositETH(admin, 15 ether);

        _depositETH(attacker, 20 ether);

        assertEq(treasury.balanceETH(), 40 ether);
    }

    function testDepositETHEmitsEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHDeposited(user, DEPOSIT_AMOUNT);

        _depositETH(user, DEPOSIT_AMOUNT);
    }

    function testReceiveFunctionEmitsEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHDeposited(user, DEPOSIT_AMOUNT);

        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: DEPOSIT_AMOUNT}("");

        assertTrue(success);

        assertEq(treasury.balanceETH(), DEPOSIT_AMOUNT);
    }

    function testReceiveFunctionUpdatesBalance() public {
        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: DEPOSIT_AMOUNT}("");

        assertTrue(success);

        assertEq(address(treasury).balance, DEPOSIT_AMOUNT);
    }

    function testRevertWhenDepositAmountIsZero() public {
        vm.prank(user);

        vm.expectRevert();

        treasury.depositETH{value: 0}();
    }

    function testAnyoneCanDepositETH() public {
        _depositETH(user, 1 ether);

        _depositETH(attacker, 2 ether);

        _depositETH(receiver, 3 ether);

        assertEq(treasury.balanceETH(), 6 ether);
    }

    function testDepositorBalanceDecreases() public {
        uint256 balanceBefore = user.balance;

        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(user.balance, balanceBefore - DEPOSIT_AMOUNT);
    }

    event ETHDeposited(address indexed sender, uint256 amount);
}
