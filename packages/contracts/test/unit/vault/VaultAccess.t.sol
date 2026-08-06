// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {Roles} from "../../../src/access/Roles.sol";

contract VaultAccessTest is VaultBase {
    function test_admin_canPause() public {
        vm.prank(admin);

        vault.pause();

        assertTrue(vault.paused());
    }

    function test_admin_canUnpause() public {
        vm.startPrank(admin);

        vault.pause();

        vault.unpause();

        vm.stopPrank();

        assertFalse(vault.paused());
    }

    function test_nonAdmin_cannotPause() public {
        vm.prank(user);

        vm.expectRevert();

        vault.pause();
    }

    function test_nonAdmin_cannotUnpause() public {
        vm.prank(user);

        vm.expectRevert();

        vault.unpause();
    }

    function test_pause_revertsIfAlreadyPaused() public {
        vm.startPrank(admin);

        vault.pause();

        vm.expectRevert();

        vault.pause();

        vm.stopPrank();
    }

    function test_unpause_revertsIfNotPaused() public {
        vm.prank(admin);

        vm.expectRevert();

        vault.unpause();
    }

    function test_accessManager_isConfigured() public view {
        assertEq(vault.accessManager(), address(accessManager));
    }
}
