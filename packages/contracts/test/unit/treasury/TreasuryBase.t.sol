// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../../src/access/AccessManager.sol";
import {Roles} from "../../../src/access/Roles.sol";

import {Treasury} from "../../../src/treasury/Treasury.sol";

import {MockERC20} from "../../mocks/MockERC20.sol";

/// @title TreasuryBaseTest
/// @author Atlas Protocol
/// @notice Contrato base para todos os testes do Treasury.
abstract contract TreasuryBaseTest is Test {
    AccessManager internal accessManager;
    Treasury internal treasury;
    MockERC20 internal mockToken;

    address internal admin = makeAddr("admin");
    address internal treasuryManager = makeAddr("treasuryManager");

    address internal user = makeAddr("user");
    address internal receiver = makeAddr("receiver");
    address internal attacker = makeAddr("attacker");

    uint256 internal constant INITIAL_ETH = 100 ether;
    uint256 internal constant INITIAL_TOKEN = 1_000_000 ether;

    function setUp() public virtual {
        vm.startPrank(admin);

        accessManager = new AccessManager(admin);

        treasury = new Treasury(address(accessManager));

        mockToken = new MockERC20();

        accessManager.grantRole(Roles.TREASURY_MANAGER_ROLE, treasuryManager);

        vm.stopPrank();

        vm.deal(admin, INITIAL_ETH);
        vm.deal(user, INITIAL_ETH);
        vm.deal(attacker, INITIAL_ETH);
        vm.deal(receiver, INITIAL_ETH);

        mockToken.mint(user, INITIAL_TOKEN);
        mockToken.mint(admin, INITIAL_TOKEN);
        mockToken.mint(attacker, INITIAL_TOKEN);
    }

    //Helpers
    function _depositETH(address depositor, uint256 amount) internal {
        vm.prank(depositor);

        treasury.depositETH{value: amount}();
    }

    function _depositToken(address depositor, uint256 amount) internal {
        vm.startPrank(depositor);

        mockToken.approve(address(treasury), amount);

        treasury.depositToken(address(mockToken), amount);

        vm.stopPrank();
    }

    function _withdrawETH(address payable to, uint256 amount) internal {
        vm.prank(treasuryManager);

        treasury.withdrawETH(to, amount);
    }

    function _withdrawToken(address to, uint256 amount) internal {
        vm.prank(treasuryManager);

        treasury.withdrawToken(address(mockToken), to, amount);
    }
}
