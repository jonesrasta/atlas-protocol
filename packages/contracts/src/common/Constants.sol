// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library Constants {
    /**
     * @notice Basis points denominator.
     * 10000 = 100%
     */
    uint256 internal constant BPS_DENOMINATOR = 10_000;

    /**
     * @notice Seconds per day.
     */
    uint256 internal constant DAY = 1 days;

    /**
     * @notice Zero value.
     */
    uint256 internal constant ZERO = 0;

    /**
     * @notice Maximum uint256.
     */
    uint256 internal constant MAX_UINT = type(uint256).max;
}
