// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/// @title Atlas Protocol Treasury Interface
/// @notice Interface for the Atlas Protocol Treasury.

interface ITreasury {
    /// @notice Deposits ETH into the Treasury.
    function depositETH() external payable;

    /// @notice Withdraws ETH from the Treasury.
    function withdrawETH(address payable receiver, uint256 amount) external;

    /// @notice Deposits ERC20 tokens into the Treasury.
    function depositToken(address token, uint256 amount) external;

    /// @notice Withdraws ERC20 tokens from the Treasury.
    function withdrawToken(address token, address receiver, uint256 amount) external;

    /// @notice Returns the Treasury ETH balance.
    function balanceETH() external view returns (uint256);

    /// @notice Returns the Treasury balance of an ERC20 token.
    function tokenBalance(address token) external view returns (uint256);

    /// @notice Returns the configured AccessManager.
    function accessManager() external view returns (address);
}
