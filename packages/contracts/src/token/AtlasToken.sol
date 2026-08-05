// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Roles} from "../access/Roles.sol";

import {AtlasTokenBase} from "./AtlasTokenBase.sol";
import {AtlasTokenStorage} from "./AtlasTokenStorage.sol";
import {IAtlasToken} from "./IAtlasToken.sol";

import {AccessControlled} from "../common/AccessControlled.sol";
import {Validation} from "../common/Validation.sol";

import "./TokenEvents.sol";

contract AtlasToken is AtlasTokenBase, AtlasTokenStorage, AccessControlled, IAtlasToken {
    constructor(address accessManager_) AtlasTokenBase("Atlas Token", "ATLAS") AccessControlled(accessManager_) {}

    function accessManager() external view override(IAtlasToken) returns (address) {
        return address(_accessManager);
    }

    function mint(address to, uint256 amount) external override onlyRole(Roles.MINTER_ROLE) {
        Validation.validateAddress(to);

        Validation.validateAmount(amount);

        _mint(to, amount);

        emit Mint(to, amount);
    }

    function burn(address from, uint256 amount) external override onlyRole(Roles.BURNER_ROLE) {
        Validation.validateAddress(from);

        Validation.validateAmount(amount);

        _burn(from, amount);

        emit Burn(from, amount);
    }
}
