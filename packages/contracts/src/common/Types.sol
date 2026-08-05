// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library Types {
    enum Status {
        NONE,
        ACTIVE,
        PAUSED,
        CLOSED
    }

    struct Asset {
        address token;
        uint256 amount;
    }
}
