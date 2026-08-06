// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;



event ETHDeposited(
    address indexed sender,
    uint256 amount
);

event ETHWithdrawn(
    address indexed receiver,
    uint256 amount
);

event TokenDeposited(
    address indexed token,
    address indexed sender,
    uint256 amount
);

event TokenWithdrawn(
    address indexed token,
    address indexed receiver,
    uint256 amount
);
