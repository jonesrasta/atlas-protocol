// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/// @title Atlas Protocol Roles
/// @notice Centralizes all role identifiers used across the Atlas Protocol.
library Roles {
    // =============================================================
    // Governance
    // =============================================================

    /// @notice Protocol-level administrator role.
    bytes32 internal constant PROTOCOL_ADMIN_ROLE =
        keccak256("PROTOCOL_ADMIN_ROLE");

    // =============================================================
    // Treasury
    // =============================================================

    /// @notice Role authorized to manage Treasury operations.
    bytes32 internal constant TREASURY_MANAGER_ROLE =
        keccak256("TREASURY_MANAGER_ROLE");

    // =============================================================
    // Vault
    // =============================================================

    /// @notice Role authorized to manage Vault operations.
    bytes32 internal constant VAULT_MANAGER_ROLE =
        keccak256("VAULT_MANAGER_ROLE");

    // =============================================================
    // Pool
    // =============================================================

    /// @notice Role authorized to manage Pool operations.
    bytes32 internal constant POOL_MANAGER_ROLE =
        keccak256("POOL_MANAGER_ROLE");

    // =============================================================
    // Oracle
    // =============================================================

    /// @notice Role authorized to manage Oracle operations.
    bytes32 internal constant ORACLE_MANAGER_ROLE =
        keccak256("ORACLE_MANAGER_ROLE");

    // =============================================================
    // Emergency / Security
    // =============================================================

    /// @notice Role authorized to pause protocol operations.
    bytes32 internal constant PAUSER_ROLE =
        keccak256("PAUSER_ROLE");

    /// @notice Role authorized to authorize contract upgrades.
    bytes32 internal constant UPGRADER_ROLE =
        keccak256("UPGRADER_ROLE");

    // =============================================================
    // Token
    // =============================================================

    /// @notice Role authorized to mint Atlas tokens.
    bytes32 internal constant MINTER_ROLE =
        keccak256("MINTER_ROLE");

    /// @notice Role authorized to burn Atlas tokens.
    bytes32 internal constant BURNER_ROLE =
        keccak256("BURNER_ROLE");
}
