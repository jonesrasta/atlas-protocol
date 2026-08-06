// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC4626} from "@openzeppelin/token/ERC20/extensions/ERC4626.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {AccessControlled} from "../common/AccessControlled.sol";
import {Roles} from "../access/Roles.sol";

import {IAtlasVault} from "./IAtlasVault.sol";
import {AtlasVaultStorage} from "./AtlasVaultStorage.sol";
import {VaultEvents} from "./VaultEvents.sol";
import {AlreadyPaused, NotPaused, VaultIsPaused} from "./VaultErrors.sol";

contract AtlasVault is ERC4626, AccessControlled, AtlasVaultStorage, IAtlasVault, VaultEvents {
    constructor(IERC20 asset_, address accessManager_)
        ERC4626(asset_)
        ERC20("Atlas Vault Share", "aATLAS")
        AccessControlled(accessManager_)
    {}

    function accessManager() external view override returns (address) {
        return address(_accessManager);
    }

    function paused() external view override returns (bool) {
        return _paused;
    }

    function pause() external override onlyRole(Roles.PROTOCOL_ADMIN_ROLE) {
        if (_paused) {
            revert AlreadyPaused();
        }

        _paused = true;

        emit VaultPaused(msg.sender);
    }

    function unpause() external override onlyRole(Roles.PROTOCOL_ADMIN_ROLE) {
        if (!_paused) {
            revert NotPaused();
        }

        _paused = false;

        emit VaultUnpaused(msg.sender);
    }

    function deposit(uint256 assets, address receiver) public override(ERC4626, IAtlasVault) returns (uint256 shares) {
        if (_paused) {
            revert VaultIsPaused();
        }

        shares = super.deposit(assets, receiver);

        emit Deposited(msg.sender, receiver, assets, shares);
    }

    function mint(uint256 shares, address receiver) public override(ERC4626, IAtlasVault) returns (uint256 assets) {
        if (_paused) {
            revert VaultIsPaused();
        }

        assets = super.mint(shares, receiver);

        emit Minted(msg.sender, receiver, assets, shares);
    }

    function withdraw(uint256 assets, address receiver, address owner)
        public
        override(ERC4626, IAtlasVault)
        returns (uint256 shares)
    {
        if (_paused) {
            revert VaultIsPaused();
        }

        shares = super.withdraw(assets, receiver, owner);

        emit Withdrawn(msg.sender, receiver, owner, assets, shares);
    }

    function redeem(uint256 shares, address receiver, address owner)
        public
        override(ERC4626, IAtlasVault)
        returns (uint256 assets)
    {
        if (_paused) {
            revert VaultIsPaused();
        }

        assets = super.redeem(shares, receiver, owner);

        emit Redeemed(msg.sender, receiver, owner, assets, shares);
    }
}
