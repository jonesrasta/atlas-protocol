// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

abstract contract VaultEvents {
    event Deposited(address indexed caller, address indexed receiver, uint256 assets, uint256 shares);

    event Minted(address indexed caller, address indexed receiver, uint256 assets, uint256 shares);

    event Withdrawn(
        address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    event Redeemed(
        address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    event VaultPaused(address indexed account);

    event VaultUnpaused(address indexed account);
}
