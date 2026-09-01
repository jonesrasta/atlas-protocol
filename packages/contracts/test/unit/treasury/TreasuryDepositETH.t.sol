// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {TreasuryBaseTest} from "./TreasuryBase.t.sol";

import {TreasuryErrors} from "../../../src/treasury/TreasuryErrors.sol";

/// @title TreasuryDepositETHTest
/// @author Atlas Protocol
/// @notice Testes de depósito de ETH no Treasury.

contract TreasuryDepositETHTest is TreasuryBaseTest {
    uint256 internal constant DEPOSIT_AMOUNT = 10 ether;

    event ETHDeposited(address indexed sender, uint256 amount);

    // =============================================================
    //                         SUCCESS
    // =============================================================

    function test_depositETH_transfersETHToTreasury() public {
        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(treasury.balanceETH(), DEPOSIT_AMOUNT);

        assertEq(address(treasury).balance, DEPOSIT_AMOUNT);
    }

    function test_depositETH_updatesTreasuryBalance() public {
        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(treasury.balanceETH(), address(treasury).balance);
    }

    function test_depositETH_emitsEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHDeposited(user, DEPOSIT_AMOUNT);

        _depositETH(user, DEPOSIT_AMOUNT);
    }

    function test_depositETH_decreasesDepositorBalance() public {
        uint256 balanceBefore = user.balance;

        _depositETH(user, DEPOSIT_AMOUNT);

        assertEq(user.balance, balanceBefore - DEPOSIT_AMOUNT);
    }

    function test_depositETH_allowsAnyoneToDeposit() public {
        _depositETH(user, 1 ether);
        _depositETH(attacker, 2 ether);
        _depositETH(receiver, 3 ether);

        assertEq(treasury.balanceETH(), 6 ether);
    }

    function test_depositETH_multipleDepositsAccumulate() public {
        _depositETH(user, 5 ether);
        _depositETH(admin, 15 ether);
        _depositETH(attacker, 20 ether);

        assertEq(treasury.balanceETH(), 40 ether);
    }

    // =============================================================
    //                         RECEIVE
    // =============================================================

    function test_receive_transfersETHToTreasury() public {
        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: DEPOSIT_AMOUNT}("");

        assertTrue(success);

        assertEq(treasury.balanceETH(), DEPOSIT_AMOUNT);
    }

    function test_receive_emitsEvent() public {
        vm.expectEmit(true, false, false, true);

        emit ETHDeposited(user, DEPOSIT_AMOUNT);

        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: DEPOSIT_AMOUNT}("");

        assertTrue(success);
    }

    function test_receive_updatesTreasuryBalance() public {
        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: DEPOSIT_AMOUNT}("");

        assertTrue(success);

        assertEq(address(treasury).balance, DEPOSIT_AMOUNT);

        assertEq(treasury.balanceETH(), address(treasury).balance);
    }

    // =============================================================
    //                         VALIDATION
    // =============================================================

    function test_depositETH_revertsWhenAmountIsZero() public {
        vm.expectRevert(TreasuryErrors.InvalidAmount.selector);

        vm.prank(user);

        treasury.depositETH{value: 0}();
    }

    function test_receive_revertsWhenAmountIsZero() public {
        vm.prank(user);

        (bool success,) = payable(address(treasury)).call{value: 0}("");

        assertFalse(success);
    }
}

