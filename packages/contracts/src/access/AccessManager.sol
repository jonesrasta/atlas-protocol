// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "@openzeppelin/access/AccessControl.sol";

import {IAccessManager} from "./IAccessManager.sol";
import {Roles} from "./Roles.sol";

import {CommonErrors} from "../common/CommonErrors.sol";

contract AccessManager is AccessControl, IAccessManager {
    constructor(address admin) {
        if (admin == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(Roles.PROTOCOL_ADMIN_ROLE, admin);
    }

    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, msg.sender)) {
            revert CommonErrors.Unauthorized();
        }

        _;
    }

    function grantRole(
        bytes32 role,
        address account
    ) public override(AccessControl, IAccessManager) onlyAdmin {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _grantRole(role, account);
    }

    function revokeRole(
        bytes32 role,
        address account
    ) public override(AccessControl, IAccessManager) onlyAdmin {
        if (account == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _revokeRole(role, account);
    }

    function hasRole(
        bytes32 role,
        address account
    ) public view override(AccessControl, IAccessManager) returns (bool) {
        return super.hasRole(role, account);
    }
}
