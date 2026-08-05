// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AtlasTokenBaseTest} from "./AtlasTokenBase.t.sol";
import "../../../src/token/TokenEvents.sol";

import {Unauthorized, ZeroAddress, InvalidAmount} from "../../../src/token/TokenErrors.sol";

contract AtlasTokenMintTest is AtlasTokenBaseTest {
    function testMintSuccess() public {
        vm.prank(minter);

        atlasToken.mint(user, INITIAL_MINT);

        assertEq(atlasToken.balanceOf(user), INITIAL_MINT);
    }

    function testMintUpdatesSupply() public {
        uint256 supplyBefore = atlasToken.totalSupply();

        vm.prank(minter);

        atlasToken.mint(user, INITIAL_MINT);

        assertEq(atlasToken.totalSupply(), supplyBefore + INITIAL_MINT);
    }

    function testMintUpdatesBalance() public {
        uint256 balanceBefore = atlasToken.balanceOf(user);

        vm.prank(minter);

        atlasToken.mint(user, 500 ether);

        assertEq(atlasToken.balanceOf(user), balanceBefore + 500 ether);
    }

    function testMintZeroAddress() public {
        vm.expectRevert(ZeroAddress.selector);

        vm.prank(minter);

        atlasToken.mint(address(0), 100 ether);
    }

    function testMintZeroAmount() public {
        vm.expectRevert(InvalidAmount.selector);

        vm.prank(minter);

        atlasToken.mint(user, 0);
    }

    function testUserCannotMint() public {
        vm.expectRevert(Unauthorized.selector);

        vm.prank(user);

        atlasToken.mint(user, 100 ether);
    }

    function testMultipleMint() public {
        vm.startPrank(minter);

        atlasToken.mint(user, 100 ether);

        atlasToken.mint(user, 250 ether);

        atlasToken.mint(user, 50 ether);

        vm.stopPrank();

        assertEq(atlasToken.balanceOf(user), 400 ether);

        assertEq(atlasToken.totalSupply(), 400 ether);
    }

    function testMintEmitsEvent() public {
        vm.expectEmit(true, true, false, true);

        emit Mint(user, 100 ether);

        vm.prank(minter);

        atlasToken.mint(user, 100 ether);
    }
}
