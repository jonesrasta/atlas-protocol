// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";

import {Validation} from "../../../src/common/Validation.sol";
import {CommonErrors} from "../../../src/common/CommonErrors.sol";

contract ValidationHarness {
    function validateAddress(address account) external pure {
        Validation.validateAddress(account);
    }

    function validateAmount(uint256 amount) external pure {
        Validation.validateAmount(amount);
    }

    function validateDeadline(uint256 deadline) external view {
        Validation.validateDeadline(deadline);
    }
}

contract ValidationTest is Test {
    ValidationHarness internal harness;

    function setUp() public {
        harness = new ValidationHarness();
    }

    /*//////////////////////////////////////////////////////////////
                            ADDRESS
    //////////////////////////////////////////////////////////////*/

    function test_ValidateAddressAcceptsValidAddress() public view {
        harness.validateAddress(address(1));
    }

    function test_ValidateAddressAcceptsNonZeroAddress() public view {
        harness.validateAddress(address(0x1234));
    }

    function test_ValidateAddressRevertsForZeroAddress() public {
        vm.expectRevert(CommonErrors.ZeroAddress.selector);

        harness.validateAddress(address(0));
    }

    /*//////////////////////////////////////////////////////////////
                             AMOUNT
    //////////////////////////////////////////////////////////////*/

    function test_ValidateAmountAcceptsPositiveAmount() public view {
        harness.validateAmount(1);
    }

    function test_ValidateAmountAcceptsLargeAmount() public view {
        harness.validateAmount(type(uint256).max);
    }

    function test_ValidateAmountRevertsForZero() public {
        vm.expectRevert(CommonErrors.InvalidAmount.selector);

        harness.validateAmount(0);
    }

    /*//////////////////////////////////////////////////////////////
                            DEADLINE
    //////////////////////////////////////////////////////////////*/

    function test_ValidateDeadlineAcceptsFutureDeadline() public view {
        uint256 deadline = block.timestamp + 1 days;

        harness.validateDeadline(deadline);
    }

    function test_ValidateDeadlineAcceptsExactDeadline() public view {
        uint256 deadline = block.timestamp;

        harness.validateDeadline(deadline);
    }

    function test_ValidateDeadlineRevertsAfterExpiration() public {
        uint256 deadline = 1 days;

        vm.warp(deadline + 1);

        vm.expectRevert(CommonErrors.DeadlineExpired.selector);
        harness.validateDeadline(deadline);
    }
}
