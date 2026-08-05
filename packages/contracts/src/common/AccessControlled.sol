// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IAccessManager} from "../access/IAccessManager.sol";
import {CommonErrors} from "./CommonErrors.sol";

abstract contract AccessControlled {
    IAccessManager internal immutable _accessManager;

    constructor(address accessManager_) {
        if (accessManager_ == address(0)) {
            revert CommonErrors.ZeroAddress();
        }

        _accessManager = IAccessManager(accessManager_);
    }

    modifier onlyRole(bytes32 role) {
        if (!_accessManager.hasRole(role, msg.sender)) {
            revert CommonErrors.Unauthorized();
        }

        _;
    }

    function getAccessManager() external view returns (address) {
        return address(_accessManager);
    }
}
