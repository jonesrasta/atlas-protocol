// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {IAccessManager} from "../access/IAccessManager.sol";
import {CommonErrors} from "./CommonErrors.sol";

/// @title Atlas Protocol Access Controlled
/// @notice Base contract for contracts protected by the Atlas AccessManager.
/// @dev Stores the AccessManager as an immutable dependency.
abstract contract AccessControlled {
    // -------------------------------------------------------------------------
    // State
    // -------------------------------------------------------------------------

    /// @notice Atlas Protocol access manager.
    IAccessManager internal immutable _accessManager;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------

    /// @notice Initializes the access-controlled contract.
    /// @param accessManager_ Address of the Atlas AccessManager.
    constructor(address accessManager_) {
        if (accessManager_ == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _accessManager = IAccessManager(accessManager_);
    }

    // -------------------------------------------------------------------------
    // Modifiers
    // -------------------------------------------------------------------------

    /// @notice Restricts access to accounts holding a specific role.
    /// @param role Role required to execute the function.
    modifier onlyRole(bytes32 role) {
        if (!_accessManager.hasRole(role, msg.sender)) {
            revert CommonErrors.Unauthorized();
        }

        _;
    }

    // -------------------------------------------------------------------------
    // Views
    // -------------------------------------------------------------------------

    /// @notice Returns the configured access manager.
    /// @return The address of the Atlas AccessManager.
    function getAccessManager() external view returns (address) {
        return address(_accessManager);
    }
}
