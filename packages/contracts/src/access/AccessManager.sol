// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {AccessControl} from "@openzeppelin/access/AccessControl.sol";

import {IAccessManager} from "./IAccessManager.sol";
import {Roles} from "./Roles.sol";
import {CommonErrors} from "../common/CommonErrors.sol";

/// @title Atlas Protocol Access Manager
/// @notice Centralizes role management and access control for the Atlas Protocol.
/// @dev Uses OpenZeppelin AccessControl as the underlying role-management mechanism.
contract AccessManager is AccessControl, IAccessManager {
    /// @notice Initializes the access manager.
    /// @param admin Address that receives the default administrator
    ///        and protocol administrator roles.
    constructor(address admin) {
        if (admin == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(Roles.PROTOCOL_ADMIN_ROLE, admin);
    }

    /// @notice Restricts access to the protocol's default administrator.
    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
            revert CommonErrors.Unauthorized();
        }

        _;
    }

    /// @inheritdoc IAccessManager
    /// @dev Resolves the interface collision between AccessControl and IAccessManager.
    function hasRole(bytes32 role, address account) public view override(AccessControl, IAccessManager) returns (bool) {
        return super.hasRole(role, account);
    }

    /// @inheritdoc IAccessManager
    /// @dev Only the default administrator can grant roles.
    function grantRole(bytes32 role, address account) public override(AccessControl, IAccessManager) onlyAdmin {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _grantRole(role, account);
    }

    /// @inheritdoc IAccessManager
    /// @dev Only the default administrator can revoke roles.
    function revokeRole(bytes32 role, address account) public override(AccessControl, IAccessManager) onlyAdmin {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _revokeRole(role, account);
    }
}
