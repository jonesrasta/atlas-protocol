// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {AccessManager} from "../../src/access/AccessManager.sol";
import {Roles} from "../../src/access/Roles.sol";


contract AccessManagerTest is Test {


    AccessManager accessManager;


    address admin = address(1);

    address user = address(2);

    address minter = address(3);



    function setUp() public {

        accessManager = new AccessManager(
            admin
        );

    }



    function testDeployWithAdmin() public {

        assertTrue(
            accessManager.hasRole(
                accessManager.DEFAULT_ADMIN_ROLE(),
                admin
            )
        );

    }



    function testRejectZeroAddress() public {

        vm.expectRevert();

        new AccessManager(
            address(0)
        );

    }



    function testAdminReceivesProtocolRole() public {

        assertTrue(

            accessManager.hasRole(
                Roles.PROTOCOL_ADMIN_ROLE,
                admin
            )

        );

    }



    function testAdminCanGrantMinterRole() public {


        vm.prank(admin);


        accessManager.grantRole(
            Roles.MINTER_ROLE,
            minter
        );


        assertTrue(

            accessManager.hasRole(
                Roles.MINTER_ROLE,
                minter
            )

        );

    }




    function testAdminCanRevokeRole() public {


        vm.startPrank(admin);


        accessManager.grantRole(
            Roles.MINTER_ROLE,
            minter
        );


        accessManager.revokeRole(
            Roles.MINTER_ROLE,
            minter
        );


        vm.stopPrank();



        assertFalse(

            accessManager.hasRole(
                Roles.MINTER_ROLE,
                minter
            )

        );

    }




    function testUserCannotGrantRole() public {


        vm.prank(user);


        vm.expectRevert();


        accessManager.grantRole(
            Roles.MINTER_ROLE,
            user
        );

    }

}
