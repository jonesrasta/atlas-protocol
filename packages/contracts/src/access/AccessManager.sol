// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "@openzeppelin/access/AccessControl.sol";

import {IAccessManager} from "./IAccessManager.sol";
import {Roles} from "./Roles.sol";

import {Unauthorized, ZeroAddress} from "./AccessErrors.sol";

contract AccessManager is AccessControl, IAccessManager {
    constructor(address admin) {
        if (admin == address(0)) {
            revert ZeroAddress();
        }

        _grantRole(DEFAULT_ADMIN_ROLE, admin);

        _grantRole(Roles.PROTOCOL_ADMIN_ROLE, admin);
    }

    function grantRole(
        bytes32 role,
        address account
    )
        public
        override(AccessControl, IAccessManager)
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (account == address(0)) {
            revert ZeroAddress();
        }

        _grantRole(role, account);
    }

    function revokeRole(
        bytes32 role,
        address account
    )
        public
        override(AccessControl, IAccessManager)
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        _revokeRole(role, account);
    }

    function hasRole(
        bytes32 role,
        address account
    ) public view override(AccessControl, IAccessManager) returns (bool) {
        return super.hasRole(role, account);
    }
}
