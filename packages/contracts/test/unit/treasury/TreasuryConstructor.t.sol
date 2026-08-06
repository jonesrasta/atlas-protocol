// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";
import {MockERC20} from "../../mocks/MockERC20.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {Roles} from "../../../src/access/Roles.sol";

abstract contract TreasuryBaseTest is Test {
    Treasury internal treasury;
    AccessManager internal accessManager;
    MockERC20 internal token;

    address internal admin;
    address internal manager;
    address internal user;
    address internal attacker;
    address internal receiver;

    function setUp() public virtual {
        admin = address(1);
        manager = address(2);
        user = address(3);
        attacker = address(4);
        receiver = address(5);

        vm.startPrank(admin);

        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        token = new MockERC20();

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, manager);

        vm.stopPrank();

        vm.deal(user, 100 ether);

        vm.deal(admin, 100 ether);

        vm.deal(manager, 100 ether);

        vm.deal(attacker, 100 ether);

        vm.deal(receiver, 100 ether);
    }

    function _depositETH(address account, uint256 amount) internal {
        vm.prank(account);

        treasury.depositETH{value: amount}();
    }
}
