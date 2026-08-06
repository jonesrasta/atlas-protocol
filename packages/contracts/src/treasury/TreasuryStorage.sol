// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title TreasuryStorage
/// @author Atlas Protocol
/// @notice Armazenamento do Treasury.
abstract contract TreasuryStorage {
    mapping(address => uint256) internal _tokenBalances;
}
