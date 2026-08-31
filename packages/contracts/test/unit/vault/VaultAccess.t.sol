// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {Roles} from "../../../src/access/Roles.sol";

contract VaultAccessTest is VaultBase {
    function test_accessManager_isConfigured() public view {
        assertEq(vault.accessManager(), address(accessManager));
    }

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

    function test_paused_maxDeposit_returnsZero() public {
        vm.prank(admin);
        vault.pause();

        assertEq(vault.maxDeposit(user), 0);
    }

    function test_paused_maxMint_returnsZero() public {
        vm.prank(admin);
        vault.pause();

        assertEq(vault.maxMint(user), 0);
    }

    function test_paused_maxWithdraw_returnsZero() public {
        vm.prank(admin);
        vault.pause();

        assertEq(vault.maxWithdraw(user), 0);
    }

    function test_paused_maxRedeem_returnsZero() public {
        vm.prank(admin);
        vault.pause();

        assertEq(vault.maxRedeem(user), 0);
    }

    function test_unpaused_maxDeposit_returnsMax() public view {
        assertEq(vault.maxDeposit(user), type(uint256).max);
    }

    function test_unpaused_maxMint_returnsMax() public view {
        assertEq(vault.maxMint(user), type(uint256).max);
    }

    function test_unpaused_maxWithdraw_returnsZeroWithoutShares() public view {
        assertEq(vault.maxWithdraw(user), 0);
    }

    function test_unpaused_maxRedeem_returnsZeroWithoutShares() public view {
        assertEq(vault.maxRedeem(user), 0);
    }

    function test_unpause_restoresMaxDeposit() public {
        vm.startPrank(admin);

        vault.pause();
        assertEq(vault.maxDeposit(user), 0);

        vault.unpause();

        vm.stopPrank();

        assertEq(vault.maxDeposit(user), type(uint256).max);
    }

    function test_unpause_restoresMaxMint() public {
        vm.startPrank(admin);

        vault.pause();
        assertEq(vault.maxMint(user), 0);

        vault.unpause();

        vm.stopPrank();

        assertEq(vault.maxMint(user), type(uint256).max);
    }

    function test_unpause_restoresMaxWithdraw() public {
        vm.startPrank(admin);

        vault.pause();
        assertEq(vault.maxWithdraw(user), 0);

        vault.unpause();

        vm.stopPrank();

        assertEq(vault.maxWithdraw(user), 0);
    }

    function test_unpause_restoresMaxRedeem() public {
        vm.startPrank(admin);

        vault.pause();
        assertEq(vault.maxRedeem(user), 0);

        vault.unpause();

        vm.stopPrank();

        assertEq(vault.maxRedeem(user), 0);
    }
}

