// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/// @title Atlas Protocol Roles
/// @notice Centraliza todos os papéis utilizados pelo protocolo.
library Roles {
    // -------------------------------------------------------------------------
    // Governance
    // -------------------------------------------------------------------------

    bytes32 internal constant PROTOCOL_ADMIN_ROLE = keccak256("PROTOCOL_ADMIN_ROLE");

    // -------------------------------------------------------------------------
    // Treasury
    // -------------------------------------------------------------------------

    bytes32 internal constant TREASURY_MANAGER_ROLE = keccak256("TREASURY_MANAGER_ROLE");

    // -------------------------------------------------------------------------
    // Vault
    // -------------------------------------------------------------------------

    bytes32 internal constant VAULT_MANAGER_ROLE = keccak256("VAULT_MANAGER_ROLE");

    // -------------------------------------------------------------------------
    // Pool
    // -------------------------------------------------------------------------

    bytes32 internal constant POOL_MANAGER_ROLE = keccak256("POOL_MANAGER_ROLE");

    // -------------------------------------------------------------------------
    // Oracle
    // -------------------------------------------------------------------------

    bytes32 internal constant ORACLE_MANAGER_ROLE = keccak256("ORACLE_MANAGER_ROLE");

    // -------------------------------------------------------------------------
    // Emergency / Security
    // -------------------------------------------------------------------------

    bytes32 internal constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    bytes32 internal constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    // -------------------------------------------------------------------------
    // Token
    // -------------------------------------------------------------------------

    bytes32 internal constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bytes32 internal constant BURNER_ROLE = keccak256("BURNER_ROLE");
}
