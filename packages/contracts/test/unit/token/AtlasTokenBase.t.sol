// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {Roles} from "../../../src/access/Roles.sol";
import {AtlasToken} from "../../../src/token/AtlasToken.sol";

abstract contract AtlasTokenBaseTest is Test {
    AccessManager internal accessManager;
    AtlasToken internal atlasToken;

    address internal admin;
    address internal minter;
    address internal burner;
    address internal user;
    address internal spender;

    uint256 internal constant INITIAL_MINT = 1_000 ether;

    function setUp() public virtual {
        admin = makeAddr("admin");
        minter = makeAddr("minter");
        burner = makeAddr("burner");
        user = makeAddr("user");
        spender = makeAddr("spender");

        accessManager = new AccessManager(admin);

        atlasToken = new AtlasToken(address(accessManager));

        vm.startPrank(admin);

        accessManager.grantRole(Roles.MINTER_ROLE, minter);

        accessManager.grantRole(Roles.BURNER_ROLE, burner);

        vm.stopPrank();
    }

    function _mintToUser(uint256 amount) internal {
        vm.prank(minter);

        atlasToken.mint(user, amount);
    }

    function _burnFromUser(uint256 amount) internal {
        vm.prank(burner);

        atlasToken.burn(user, amount);
    }
}
