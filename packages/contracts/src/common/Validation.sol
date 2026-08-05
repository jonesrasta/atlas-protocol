// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CommonErrors} from "./CommonErrors.sol";

library Validation {
    function validateAddress(address account) internal pure {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }
    }

    function validateAmount(uint256 amount) internal pure {
        if (amount == 0) {
            revert CommonErrors.InvalidAmount();
        }
    }

    /**
     * @notice Validates timestamp-based deadlines.
     *
     * @dev Uses block.timestamp only as an expiration boundary.
     * Minor timestamp manipulation by block producers is acceptable.
     * This function MUST NOT be used for randomness,
     * price calculations, or consensus-critical logic.
     *
     * @param deadline Unix timestamp after which the operation expires.
     */
    function validateDeadline(uint256 deadline) internal view {
        if (block.timestamp > deadline) {
            revert CommonErrors.DeadlineExpired();
        }
    }
}
