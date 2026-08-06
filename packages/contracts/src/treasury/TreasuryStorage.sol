// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

abstract contract TreasuryStorage {
    mapping(address => uint256) internal _tokenBalances;
}
