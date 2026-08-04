// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IAccessManager} from "../access/IAccessManager.sol";
import {Roles} from "../access/Roles.sol";

import {AtlasTokenBase} from "./AtlasTokenBase.sol";
import {AtlasTokenStorage} from "./AtlasTokenStorage.sol";
import {IAtlasToken} from "./IAtlasToken.sol";

import {
    Unauthorized,
    ZeroAddress,
    InvalidAmount
} from "./TokenErrors.sol";

import "./TokenEvents.sol";

/// @title AtlasToken
/// @notice Token principal do Atlas Protocol.
contract AtlasToken is
    AtlasTokenBase,
    AtlasTokenStorage,
    IAtlasToken
{
    constructor(address accessManager_)
        AtlasTokenBase("Atlas Token", "ATLAS")
    {
        if (accessManager_ == address(0)) {
            revert ZeroAddress();
        }

        _accessManager = accessManager_;
    }

    function accessManager()
        external
        view
        override
        returns (address)
    {
        return _accessManager;
    }

    function mint(
        address,
        uint256
    )
        external
        override
    {
        revert Unauthorized();
    }

    function burn(
        address,
        uint256
    )
        external
        override
    {
        revert Unauthorized();
    }
}
