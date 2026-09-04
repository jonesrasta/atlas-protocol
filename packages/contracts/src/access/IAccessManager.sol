// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/// @title Atlas Protocol Access Manager Interface
/// @notice Defines the role-management interface used by Atlas Protocol contracts.
interface IAccessManager {
    /// @notice Checks whether an account has a specific role.
    /// @param role Role identifier.
    /// @param account Account to check.
    /// @return True if the account has the role.
    function hasRole(bytes32 role, address account) external view returns (bool);

    /// @notice Grants a role to an account.
    /// @dev Authorization is enforced by the AccessManager implementation.
    /// @param role Role identifier.
    /// @param account Account that will receive the role.
    function grantRole(bytes32 role, address account) external;

    /// @notice Revokes a role from an account.
    /// @dev Authorization is enforced by the AccessManager implementation.
    /// @param role Role identifier.
    /// @param account Account that will lose the role.
    function revokeRole(bytes32 role, address account) external;
}
