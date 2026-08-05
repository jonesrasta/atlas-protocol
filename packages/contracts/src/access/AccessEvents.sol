// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library AccessEvents {
    event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);

    event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
}
