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

    uint256 internal constant INITIAL_ETH_BALANCE = 100 ether;

    function setUp() public virtual {
        admin = makeAddr("admin");
        manager = makeAddr("manager");
        user = makeAddr("user");
        attacker = makeAddr("attacker");
        receiver = makeAddr("receiver");

        vm.startPrank(admin);

        accessManager = new AccessManager(admin);
        treasury = new Treasury(address(accessManager));
        token = new MockERC20();

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, manager);

        vm.stopPrank();

        vm.deal(admin, INITIAL_ETH_BALANCE);
        vm.deal(manager, INITIAL_ETH_BALANCE);
        vm.deal(user, INITIAL_ETH_BALANCE);
        vm.deal(attacker, INITIAL_ETH_BALANCE);
        vm.deal(receiver, INITIAL_ETH_BALANCE);
    }

    // =============================================================
    //                         HELPERS
    // =============================================================

    function _depositETH(address account, uint256 amount) internal {
        vm.prank(account);

        treasury.depositETH{value: amount}();
    }

    function _fundTreasuryETH(uint256 amount) internal {
        vm.deal(address(treasury), amount);
    }

    function _mintToken(address account, uint256 amount) internal {
        token.mint(account, amount);
    }

    function _approveToken(address account, uint256 amount) internal {
        vm.prank(account);

        token.approve(address(treasury), amount);
    }

    function _depositToken(address account, uint256 amount) internal {
        _mintToken(account, amount);
        _approveToken(account, amount);

        vm.prank(account);

        treasury.depositToken(address(token), amount);
    }
}

