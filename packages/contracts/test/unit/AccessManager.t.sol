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

    // =============================================================
    // Constructor
    // =============================================================

    function test_ConstructorSetsDefaultAdminRole() public view {
        assertTrue(accessManager.hasRole(accessManager.DEFAULT_ADMIN_ROLE(), admin));
    }

    function test_ConstructorSetsProtocolAdminRole() public view {
        assertTrue(accessManager.hasRole(Roles.PROTOCOL_ADMIN_ROLE, admin));
    }

    function test_ConstructorDoesNotGrantRolesToUser() public view {
        assertFalse(accessManager.hasRole(accessManager.DEFAULT_ADMIN_ROLE(), user));

        assertFalse(accessManager.hasRole(Roles.PROTOCOL_ADMIN_ROLE, user));
    }

    function test_ConstructorRevertsForZeroAddress() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        new AccessManager(address(0));
    }

    // =============================================================
    // Grant Role
    // =============================================================

    function test_AdminCanGrantMinterRole() public {
        vm.prank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function test_AdminCanGrantBurnerRole() public {
        vm.prank(admin);

        accessManager.grantRole(Roles.BURNER_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.BURNER_ROLE, user));
    }

    function test_AdminCanGrantProtocolAdminRole() public {
        vm.prank(admin);

        accessManager.grantRole(Roles.PROTOCOL_ADMIN_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.PROTOCOL_ADMIN_ROLE, user));
    }

    function test_GrantRoleRevertsForUnauthorizedUser() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        accessManager.grantRole(Roles.MINTER_ROLE, user);
    }

    function test_GrantRoleRevertsForZeroAddress() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        vm.prank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, address(0));
    }

    function test_GrantRoleIsIdempotent() public {
        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        vm.stopPrank();

        assertTrue(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    // =============================================================
    // Revoke Role
    // =============================================================

    function test_AdminCanRevokeRole() public {
        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.MINTER_ROLE, user));

        accessManager.revokeRole(Roles.MINTER_ROLE, user);

        vm.stopPrank();

        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function test_RevokeRoleRevertsForUnauthorizedUser() public {
        vm.expectRevert(CommonErrors.Unauthorized.selector);

        vm.prank(user);

        accessManager.revokeRole(Roles.MINTER_ROLE, user);
    }

    function test_RevokeRoleRevertsForZeroAddress() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        vm.prank(admin);

        accessManager.revokeRole(Roles.MINTER_ROLE, address(0));
    }

    function test_RevokeRoleIsIdempotent() public {
        vm.prank(admin);

        accessManager.revokeRole(Roles.MINTER_ROLE, user);

        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    // =============================================================
    // Role State
    // =============================================================

    function test_HasRoleReturnsFalseForUnassignedRole() public view {
        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function test_GrantRoleUpdatesRoleState() public {
        vm.prank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        assertTrue(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function test_RevokeRoleUpdatesRoleState() public {
        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        accessManager.revokeRole(Roles.MINTER_ROLE, user);

        vm.stopPrank();

        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));
    }

    function test_RevokeOneRoleDoesNotAffectAnotherRole() public {
        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, user);

        accessManager.grantRole(Roles.BURNER_ROLE, user);

        accessManager.revokeRole(Roles.MINTER_ROLE, user);

        vm.stopPrank();

        assertFalse(accessManager.hasRole(Roles.MINTER_ROLE, user));

        assertTrue(accessManager.hasRole(Roles.BURNER_ROLE, user));
    }

    // =============================================================
    // Authorization
    // =============================================================

    function test_UserDoesNotHaveAdminRole() public view {
        assertFalse(accessManager.hasRole(accessManager.DEFAULT_ADMIN_ROLE(), user));
    }

    function test_UserDoesNotHaveProtocolAdminRole() public view {
        assertFalse(accessManager.hasRole(Roles.PROTOCOL_ADMIN_ROLE, user));
    }
}
