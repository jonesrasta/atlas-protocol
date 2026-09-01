// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Math} from "../../../src/common/Math.sol";

contract MathTest is Test {
    /*//////////////////////////////////////////////////////////////
                              MIN
    //////////////////////////////////////////////////////////////*/

    function test_MinReturnsFirstValueWhenFirstIsSmaller() public pure {
        assertEq(Math.min(10, 20), 10);
    }

    function test_MinReturnsSecondValueWhenSecondIsSmaller() public pure {
        assertEq(Math.min(20, 10), 10);
    }

    function test_MinReturnsSameValueWhenValuesAreEqual() public pure {
        assertEq(Math.min(10, 10), 10);
    }

    function test_MinHandlesZero() public pure {
        assertEq(Math.min(0, 100), 0);
        assertEq(Math.min(100, 0), 0);
    }

    /*//////////////////////////////////////////////////////////////
                              MAX
    //////////////////////////////////////////////////////////////*/

    function test_MaxReturnsFirstValueWhenFirstIsGreater() public pure {
        assertEq(Math.max(20, 10), 20);
    }

    function test_MaxReturnsSecondValueWhenSecondIsGreater() public pure {
        assertEq(Math.max(10, 20), 20);
    }

    function test_MaxReturnsSameValueWhenValuesAreEqual() public pure {
        assertEq(Math.max(10, 10), 10);
    }

    function test_MaxHandlesZero() public pure {
        assertEq(Math.max(0, 100), 100);
        assertEq(Math.max(100, 0), 100);
    }

    /*//////////////////////////////////////////////////////////////
                          PERCENTAGE
    //////////////////////////////////////////////////////////////*/

    function test_PercentageCalculatesCorrectly() public pure {
        assertEq(Math.percentage(10_000, 1_000), 1_000);
    }

    function test_PercentageReturnsZeroForZeroAmount() public pure {
        assertEq(Math.percentage(0, 1_000), 0);
    }

    function test_PercentageReturnsZeroForZeroBasisPoints() public pure {
        assertEq(Math.percentage(10_000, 0), 0);
    }

    function test_PercentageCalculatesOnePercent() public pure {
        assertEq(Math.percentage(10_000, 100), 100);
    }

    function test_PercentageCalculatesOneHundredPercent() public pure {
        assertEq(Math.percentage(10_000, 10_000), 10_000);
    }

    function test_PercentageRoundsDown() public pure {
        assertEq(Math.percentage(999, 100), 9);
    }

    function test_PercentageHandlesLargeValues() public pure {
        uint256 amount = 1_000_000 ether;
        uint256 basisPoints = 500;

        assertEq(Math.percentage(amount, basisPoints), 50_000 ether);
    }
}

