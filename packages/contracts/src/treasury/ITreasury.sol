// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title ITreasury
/// @author Atlas Protocol
/// @notice Interface do Treasury do protocolo.
interface ITreasury {
    function depositETH() external payable;

    function withdrawETH(address payable receiver, uint256 amount) external;

    function depositToken(address token, uint256 amount) external;

    function withdrawToken(address token, address receiver, uint256 amount) external;

    function balanceETH() external view returns (uint256);

    function tokenBalance(address token) external view returns (uint256);

    function accessManager() external view returns (address);
}
