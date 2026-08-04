// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Roles} from "../../src/access/Roles.sol";


contract RolesTest is Test {

    function testProtocolAdminRoleIsValid() public {

        bytes32 role = Roles.PROTOCOL_ADMIN_ROLE;

        assertTrue(
            role != bytes32(0)
        );

    }


    function testMinterRoleIsValid() public {

        bytes32 role = Roles.MINTER_ROLE;

        assertTrue(
            role != bytes32(0)
        );

    }


    function testBurnerRoleIsValid() public {

        bytes32 role = Roles.BURNER_ROLE;

        assertTrue(
            role != bytes32(0)
        );

    }

}
