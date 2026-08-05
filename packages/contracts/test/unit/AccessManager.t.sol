// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../src/access/AccessManager.sol";
import {Roles} from "../../src/access/Roles.sol";
import {CommonErrors} from "../../src/common/CommonErrors.sol";

contract AccessManagerTest is Test {
    AccessManager internal accessManager;

    address internal admin;
    address internal user;

    function setUp() public {
        admin = makeAddr("admin");
        user = makeAddr("user");

        accessManager = new AccessManager(admin);
    }

    function testDeployWithAdmin() public view {
        assertTrue(
            accessManager.hasRole(accessManager.DEFAULT_ADMIN_ROLE(), admin)
        );
    }

    function testAdminReceivesProtocolRole() public view {
        assertTrue(accessManager.hasRole(Roles.PROTOCOL_ADMIN_ROLE, admin));
    }

    function testRejectZeroAddress() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        new AccessManager(address(0));
    }

    function testAdminCanGrantMinterRole() public {
        vm.prank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function testAdminCanRevokeRole() public {
        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        accessManager.revokeRole(Roles.MINTER_ROLE, user);

        vm.stopPrank();

        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function testUserCannotGrantRole() public {
        vm.expectRevert(abi.encodeWithSelector(CommonErrors.Unauthorized.selector));

        vm.prank(user);

        accessManager.grantRole(Roles.MINTER_ROLE, user);
    }
}
