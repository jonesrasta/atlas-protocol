// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AtlasVault} from "../../../src/vault/AtlasVault.sol";
import {AtlasToken} from "../../../src/token/AtlasToken.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {Roles} from "../../../src/access/Roles.sol";

abstract contract VaultBase is Test {
    AtlasToken internal asset;
    AtlasVault internal vault;
    AccessManager internal accessManager;

    address internal admin = makeAddr("admin");

    address internal user = makeAddr("user");
    address internal user2 = makeAddr("user2");

    function setUp() public virtual {
        accessManager = new AccessManager(admin);

        asset = new AtlasToken(address(accessManager));

        vault = new AtlasVault(asset, address(accessManager));

        vm.startPrank(admin);

        accessManager.grantRole(Roles.PROTOCOL_ADMIN_ROLE, admin);

        accessManager.grantRole(Roles.MINTER_ROLE, admin);

        vm.stopPrank();
    }

    function mintAsset(address to, uint256 amount) internal {
        vm.prank(admin);

        asset.mint(to, amount);
    }
}

