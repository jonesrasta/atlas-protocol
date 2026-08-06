// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";
import {MockERC20} from "../../mocks/MockERC20.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {Roles} from "../../../src/access/Roles.sol";
import {TreasuryErrors} from "../../../src/treasury/TreasuryErrors.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract TreasuryWithdrawTokenTest is Test {
    Treasury treasury;
    AccessManager accessManager;
    MockERC20 token;

    address admin = address(1);
    address manager = address(2);
    address receiver = address(3);
    address user = address(4);

    uint256 constant INITIAL_DEPOSIT = 1000 ether;
    uint256 constant WITHDRAW_AMOUNT = 250 ether;

    function setUp() public {
        vm.startPrank(admin);

        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, manager);

        vm.stopPrank();

        token = new MockERC20();

        token.mint(address(this), INITIAL_DEPOSIT);

        token.approve(address(treasury), INITIAL_DEPOSIT);

        treasury.depositToken(address(token), INITIAL_DEPOSIT);
    }

    function test_WithdrawToken() public {
        uint256 receiverBefore = token.balanceOf(receiver);

        vm.prank(manager);

        treasury.withdrawToken(address(token), receiver, WITHDRAW_AMOUNT);

        assertEq(token.balanceOf(receiver), receiverBefore + WITHDRAW_AMOUNT);

        assertEq(
            treasury.tokenBalance(address(token)),
            INITIAL_DEPOSIT - WITHDRAW_AMOUNT
        );
    }

    function test_EmitTokenWithdrawnEvent() public {
        vm.expectEmit(true, true, false, true);

        emit TokenWithdrawn(address(token), receiver, WITHDRAW_AMOUNT);

        vm.prank(manager);

        treasury.withdrawToken(address(token), receiver, WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_UserWithoutRoleWithdrawsToken() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        treasury.withdrawToken(address(token), receiver, WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_WithdrawExceedsTokenBalance() public {
        vm.expectRevert(TreasuryErrors.InsufficientBalance.selector);

        vm.prank(manager);

        treasury.withdrawToken(
            address(token),
            receiver,
            INITIAL_DEPOSIT + 1 ether
        );
    }

    function test_RevertWhen_TokenAddressIsZero() public {
        vm.expectRevert();

        vm.prank(manager);

        treasury.withdrawToken(address(0), receiver, WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_ReceiverIsZeroAddress() public {
        vm.expectRevert();

        vm.prank(manager);

        treasury.withdrawToken(address(token), address(0), WITHDRAW_AMOUNT);
    }

    function test_RevertWhen_AmountIsZero() public {
        vm.expectRevert();

        vm.prank(manager);

        treasury.withdrawToken(address(token), receiver, 0);
    }

    function test_ManagerCanWithdrawEntireTokenBalance() public {
        vm.prank(manager);

        treasury.withdrawToken(address(token), receiver, INITIAL_DEPOSIT);

        assertEq(treasury.tokenBalance(address(token)), 0);

        assertEq(token.balanceOf(receiver), INITIAL_DEPOSIT);
    }

    function test_MultipleWithdrawalsReduceTokenBalance() public {
        vm.startPrank(manager);

        treasury.withdrawToken(address(token), receiver, 100 ether);

        treasury.withdrawToken(address(token), receiver, 200 ether);

        vm.stopPrank();

        assertEq(treasury.tokenBalance(address(token)), 700 ether);

        assertEq(token.balanceOf(receiver), 300 ether);
    }

    function test_DifferentTokensMaintainIndependentBalances() public {
        MockERC20 secondToken = new MockERC20();

        secondToken.mint(address(this), 500 ether);

        secondToken.approve(address(treasury), 500 ether);

        treasury.depositToken(address(secondToken), 500 ether);

        vm.prank(manager);

        treasury.withdrawToken(address(secondToken), receiver, 100 ether);

        assertEq(treasury.tokenBalance(address(token)), INITIAL_DEPOSIT);

        assertEq(treasury.tokenBalance(address(secondToken)), 400 ether);
    }

    event TokenWithdrawn(
        address indexed token,
        address indexed receiver,
        uint256 amount
    );
}
