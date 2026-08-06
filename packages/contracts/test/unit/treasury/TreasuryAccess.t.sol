// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";
import {MockERC20} from "../../mocks/MockERC20.sol";

import {Roles} from "../../../src/access/Roles.sol";
import {AccessManager} from "../../../src/access/AccessManager.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract TreasuryAccessTest is Test {
    Treasury treasury;
    AccessManager accessManager;
    MockERC20 token;

    address admin = address(1);
    address manager = address(2);
    address user = address(3);

    uint256 constant AMOUNT = 100 ether;

    function setUp() public {
        vm.startPrank(admin);

        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        token = new MockERC20();

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, manager);

        vm.stopPrank();

        vm.deal(address(treasury), 100 ether);

        token.mint(address(this), 1000 ether);

        token.approve(address(treasury), 1000 ether);

        treasury.depositToken(address(token), 1000 ether);
    }

    function test_ManagerCanWithdrawETH() public {
        uint256 balanceBefore = manager.balance;

        vm.prank(manager);

        treasury.withdrawETH(payable(manager), AMOUNT);

        assertEq(manager.balance, balanceBefore + AMOUNT);
    }

    function test_RevertWhen_UserWithdrawsETHWithoutRole() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        treasury.withdrawETH(payable(user), AMOUNT);
    }

    function test_ManagerCanWithdrawToken() public {
        uint256 beforeBalance = token.balanceOf(manager);

        vm.prank(manager);

        treasury.withdrawToken(address(token), manager, 100 ether);

        assertEq(token.balanceOf(manager), beforeBalance + 100 ether);

        assertEq(treasury.tokenBalance(address(token)), 900 ether);
    }

    function test_RevertWhen_UserWithdrawsTokenWithoutRole() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        treasury.withdrawToken(address(token), user, 100 ether);
    }

    function test_AdminCanGrantTreasuryRole() public {
        address newManager = address(10);

        vm.prank(admin);

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, newManager);

        assertTrue(
            accessManager.hasRole(Roles.TREASURY_MANAGER_ROLE, newManager)
        );
    }

    function test_AdminCanRevokeTreasuryRole() public {
        vm.prank(admin);

        accessManager.revokeRole(Roles.TREASURY_MANAGER_ROLE, manager);

        assertFalse(
            accessManager.hasRole(Roles.TREASURY_MANAGER_ROLE, manager)
        );
    }

    function test_RevertWhen_UserGrantsRole() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, user);
    }
}
