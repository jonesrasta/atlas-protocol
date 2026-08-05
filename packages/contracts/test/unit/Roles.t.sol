// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Roles} from "../../src/access/Roles.sol";

contract RolesTest is Test {
    function testProtocolAdminRoleIsValid() public pure {
        assertEq(Roles.PROTOCOL_ADMIN_ROLE, keccak256("PROTOCOL_ADMIN_ROLE"));
    }

    function testMinterRoleIsValid() public pure {
        assertEq(Roles.MINTER_ROLE, keccak256("MINTER_ROLE"));
    }

    function testBurnerRoleIsValid() public pure {
        assertEq(Roles.BURNER_ROLE, keccak256("BURNER_ROLE"));
    }
}
