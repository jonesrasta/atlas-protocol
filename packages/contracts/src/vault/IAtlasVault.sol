// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Atlas Vault Interface
/// @author Atlas Protocol
/// @notice Interface for the Atlas ERC4626 Vault.
interface IAtlasVault {
    function accessManager() external view returns (address);

    function paused() external view returns (bool);

    function pause() external;

    function unpause() external;

    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    function mint(uint256 shares, address receiver) external returns (uint256 assets);

    function withdraw(uint256 assets, address receiver, address owner) external returns (uint256 shares);

    function redeem(uint256 shares, address receiver, address owner) external returns (uint256 assets);
}
