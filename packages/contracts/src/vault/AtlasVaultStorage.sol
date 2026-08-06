// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Atlas Vault Storage
/// @author Atlas Protocol
/// @notice Storage layout for the Atlas Vault contract.
abstract contract AtlasVaultStorage {
    /// @dev Indicates whether the vault is paused.
    bool internal _paused;
}
