// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";
import {MockERC20} from "../../mocks/MockERC20.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";

contract TreasuryDepositTokenTest is Test {
    Treasury treasury;
    AccessManager accessManager;
    MockERC20 token;

    address admin = address(10);
    address user = address(1);

    uint256 constant DEPOSIT_AMOUNT = 500 ether;

    function setUp() public {
        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        token = new MockERC20();

        token.mint(user, 1000 ether);

        vm.startPrank(user);

        token.approve(address(treasury), type(uint256).max);

        vm.stopPrank();
    }

    function test_DepositToken() public {
        vm.prank(user);

        treasury.depositToken(address(token), DEPOSIT_AMOUNT);

        assertEq(token.balanceOf(address(treasury)), DEPOSIT_AMOUNT);

        assertEq(treasury.tokenBalance(address(token)), DEPOSIT_AMOUNT);
    }

    function test_EmitTokenDepositedEvent() public {
        vm.expectEmit(true, true, false, true);

        emit TokenDeposited(address(token), user, DEPOSIT_AMOUNT);

        vm.prank(user);

        treasury.depositToken(address(token), DEPOSIT_AMOUNT);
    }

    function test_RevertWhen_DepositZeroAmount() public {
        vm.expectRevert();

        vm.prank(user);

        treasury.depositToken(address(token), 0);
    }

    function test_RevertWhen_DepositInvalidToken() public {
        vm.expectRevert();

        vm.prank(user);

        treasury.depositToken(address(0), DEPOSIT_AMOUNT);
    }

    function test_MultipleDepositsIncreaseBalance() public {
        vm.startPrank(user);

        treasury.depositToken(address(token), 100 ether);

        treasury.depositToken(address(token), 200 ether);

        vm.stopPrank();

        assertEq(treasury.tokenBalance(address(token)), 300 ether);
    }

    function test_DifferentTokensHaveIndependentBalances() public {
        MockERC20 secondToken = new MockERC20();

        secondToken.mint(user, 500 ether);

        vm.startPrank(user);

        secondToken.approve(address(treasury), 500 ether);

        treasury.depositToken(address(token), 100 ether);

        treasury.depositToken(address(secondToken), 200 ether);

        vm.stopPrank();

        assertEq(treasury.tokenBalance(address(token)), 100 ether);

        assertEq(treasury.tokenBalance(address(secondToken)), 200 ether);
    }

    event TokenDeposited(address indexed token, address indexed sender, uint256 amount);
}
