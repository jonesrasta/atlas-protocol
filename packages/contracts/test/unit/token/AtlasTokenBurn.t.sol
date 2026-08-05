// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AtlasTokenBaseTest} from "./AtlasTokenBase.t.sol";

import {Unauthorized, ZeroAddress, InvalidAmount} from "../../../src/token/TokenErrors.sol";

contract AtlasTokenBurnTest is AtlasTokenBaseTest {
    function testBurnSuccess() public {
        vm.prank(minter);
        atlasToken.mint(user, INITIAL_MINT);

        uint256 balanceBefore = atlasToken.balanceOf(user);
        uint256 supplyBefore = atlasToken.totalSupply();

        vm.prank(burner);
        atlasToken.burn(user, 100 ether);

        assertEq(atlasToken.balanceOf(user), balanceBefore - 100 ether);

        assertEq(atlasToken.totalSupply(), supplyBefore - 100 ether);
    }

    function testRevertWhenCallerIsNotBurner() public {
        vm.prank(minter);
        atlasToken.mint(user, INITIAL_MINT);

        vm.expectRevert(Unauthorized.selector);

        vm.prank(user);
        atlasToken.burn(user, 100 ether);
    }

    function testRevertWhenBurnAddressIsZero() public {
        vm.expectRevert(ZeroAddress.selector);

        vm.prank(burner);

        atlasToken.burn(address(0), 100 ether);
    }

    function testRevertWhenAmountIsZero() public {
        vm.expectRevert(InvalidAmount.selector);

        vm.prank(burner);

        atlasToken.burn(user, 0);
    }

    function testRevertWhenBurnExceedsBalance() public {
        vm.expectRevert();

        vm.prank(burner);

        atlasToken.burn(user, 1 ether);
    }
}
