// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";
import {VaultEvents} from "../../../src/vault/VaultEvents.sol";

contract VaultMintTest is VaultBase, VaultEvents {
    uint256 internal constant SHARES_AMOUNT = 100 ether;

    function setUp() public override {
        super.setUp();

        mintAsset(user, SHARES_AMOUNT);
    }

    function test_mint_createsShares() public {
        vm.startPrank(user);

        asset.approve(address(vault), SHARES_AMOUNT);

        uint256 assets = vault.mint(SHARES_AMOUNT, user);

        vm.stopPrank();

        assertEq(assets, SHARES_AMOUNT);

        assertEq(vault.balanceOf(user), SHARES_AMOUNT);

        assertEq(vault.totalAssets(), SHARES_AMOUNT);
    }

    function test_mint_emitsEvent() public {
        vm.startPrank(user);

        asset.approve(address(vault), SHARES_AMOUNT);

        vm.expectEmit(true, true, false, true);

        emit Minted(user, user, SHARES_AMOUNT, SHARES_AMOUNT);

        vault.mint(SHARES_AMOUNT, user);

        vm.stopPrank();
    }

    function test_mint_revertsWhenPaused() public {
        vm.prank(admin);

        vault.pause();

        vm.startPrank(user);

        asset.approve(address(vault), SHARES_AMOUNT);

        vm.expectRevert();

        vault.mint(SHARES_AMOUNT, user);

        vm.stopPrank();
    }
}
