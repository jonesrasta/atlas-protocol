// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {CommonErrors} from "./CommonErrors.sol";

library Validation {
    /**
     * @notice Validates that an address is not the zero address.
     *
     * @param account Address to validate.
     *
     * @dev Reverts with {CommonErrors.ZeroAddress} when `account` is zero.
     */
    function validateAddress(address account) internal pure {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }
    }

    /**
     * @notice Validates that an amount is greater than zero.
     *
     * @param amount Amount to validate.
     *
     * @dev Reverts with {CommonErrors.InvalidAmount} when `amount` is zero.
     */
    function validateAmount(uint256 amount) internal pure {
        if (amount == 0) {
            revert CommonErrors.InvalidAmount();
        }
    }

    /**
     * @notice Validates that a deadline has not expired.
     *
     * @param deadline Unix timestamp after which the operation expires.
     *
     * @dev The deadline remains valid when `block.timestamp == deadline`.
     * Reverts only when `block.timestamp > deadline`.
     *
     * This function MUST NOT be used for randomness,
     * price calculations, or consensus-critical logic.
     */
    function validateDeadline(uint256 deadline) internal view {
        if (block.timestamp > deadline) {
            revert CommonErrors.DeadlineExpired();
        }
    }
}
