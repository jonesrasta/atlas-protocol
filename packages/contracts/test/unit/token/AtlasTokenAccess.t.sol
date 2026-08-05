// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AtlasTokenBaseTest} from "./AtlasTokenBase.t.sol";

import {Unauthorized} from "../../../src/token/TokenErrors.sol";

contract AtlasTokenAccessTest is AtlasTokenBaseTest {
    function testMinterRoleCanMint() public {
        vm.prank(minter);

        atlasToken.mint(user, 100 ether);

        assertEq(atlasToken.balanceOf(user), 100 ether);
    }

    function testBurnerRoleCanBurn() public {
        vm.prank(minter);

        atlasToken.mint(user, INITIAL_MINT);

        vm.prank(burner);

        atlasToken.burn(user, 100 ether);

        assertEq(atlasToken.balanceOf(user), INITIAL_MINT - 100 ether);
    }

    function testUserCannotMint() public {
        vm.expectRevert(Unauthorized.selector);

        vm.prank(user);

        atlasToken.mint(user, 100 ether);
    }

    function testUserCannotBurn() public {
        vm.prank(minter);

        atlasToken.mint(user, INITIAL_MINT);

        vm.expectRevert(Unauthorized.selector);

        vm.prank(user);

        atlasToken.burn(user, 100 ether);
    }

    function testAdminCannotMintWithoutRole() public {
        vm.expectRevert(Unauthorized.selector);

        vm.prank(admin);

        atlasToken.mint(user, 100 ether);
    }

    function testAdminCannotBurnWithoutRole() public {
        vm.prank(minter);

        atlasToken.mint(user, INITIAL_MINT);

        vm.expectRevert(Unauthorized.selector);

        vm.prank(admin);

        atlasToken.burn(user, 100 ether);
    }
}
