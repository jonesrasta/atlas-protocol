// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {AtlasToken} from "../../../src/token/AtlasToken.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract AtlasTokenConstructorTest is Test {
    AccessManager internal accessManager;
    AtlasToken internal atlasToken;

    address internal admin;

    function setUp() public {
        admin = makeAddr("admin");

        accessManager = new AccessManager(admin);

        atlasToken = new AtlasToken(address(accessManager));
    }

    function testAccessManagerSaved() public view {
        assertEq(atlasToken.accessManager(), address(accessManager));
    }

    function testName() public view {
        assertEq(atlasToken.name(), "Atlas Token");
    }

    function testSymbol() public view {
        assertEq(atlasToken.symbol(), "ATLAS");
    }

    function testDecimals() public view {
        assertEq(atlasToken.decimals(), 18);
    }

    function testRejectZeroAccessManager() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        new AtlasToken(address(0));
    }
}
