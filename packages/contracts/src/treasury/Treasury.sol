// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";

import "../access/Roles.sol";
import "../common/AccessControlled.sol";
import "../common/Validation.sol";

import "./ITreasury.sol";
import "./TreasuryErrors.sol";
import "./TreasuryEvents.sol";

/// @title Atlas Protocol Treasury
/// @author Atlas Protocol
/// @notice Custodia ETH e tokens ERC20 do protocolo.
/// @dev Toda movimentação de saída é restrita ao TREASURY_MANAGER_ROLE.
contract Treasury is AccessControlled, ITreasury, ReentrancyGuard {
    using SafeERC20 for IERC20;

    constructor(address accessManager_) AccessControlled(accessManager_) {}

    // =============================================================
    //                         VIEW FUNCTIONS
    // =============================================================

    /// @inheritdoc ITreasury
    function accessManager() external view override returns (address) {
        return address(_accessManager);
    }

    /// @inheritdoc ITreasury
    function balanceETH() external view override returns (uint256) {
        return address(this).balance;
    }

    /// @inheritdoc ITreasury
    function tokenBalance(address token) external view override returns (uint256) {
        Validation.validateAddress(token);

        return IERC20(token).balanceOf(address(this));
    }

    // =============================================================
    //                         ETH FUNCTIONS
    // =============================================================

    /// @inheritdoc ITreasury
    function depositETH() external payable override {
        Validation.validateAmount(msg.value);

        emit ETHDeposited(msg.sender, msg.value);
    }

    /// @inheritdoc ITreasury
    function withdrawETH(address payable receiver, uint256 amount)
        external
        override
        onlyRole(Roles.TREASURY_MANAGER_ROLE)
        nonReentrant
    {
        Validation.validateAddress(receiver);
        Validation.validateAmount(amount);

        if (address(this).balance < amount) {
            revert TreasuryErrors.InsufficientBalance();
        }

        _sendETH(receiver, amount);

        emit ETHWithdrawn(receiver, amount);
    }

    /// @notice Sends ETH to a receiver.
    /// @param receiver Address receiving the ETH.
    /// @param amount Amount of ETH to send.
    /// @dev Uses a low-level call and reverts if the transfer fails.
    function _sendETH(address payable receiver, uint256 amount) internal {
        (bool success,) = receiver.call{value: amount}("");

        if (!success) {
            revert TreasuryErrors.TransferFailed();
        }
    }

    // =============================================================
    //                       TOKEN FUNCTIONS
    // =============================================================

    /// @inheritdoc ITreasury
    function depositToken(address token, uint256 amount) external override {
        Validation.validateAddress(token);
        Validation.validateAmount(amount);

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        emit TokenDeposited(token, msg.sender, amount);
    }

    /// @inheritdoc ITreasury
    function withdrawToken(address token, address receiver, uint256 amount)
        external
        override
        onlyRole(Roles.TREASURY_MANAGER_ROLE)
        nonReentrant
    {
        Validation.validateAddress(token);
        Validation.validateAddress(receiver);
        Validation.validateAmount(amount);

        IERC20 asset = IERC20(token);

        if (asset.balanceOf(address(this)) < amount) {
            revert TreasuryErrors.InsufficientBalance();
        }

        asset.safeTransfer(receiver, amount);

        emit TokenWithdrawn(token, receiver, amount);
    }

    // =============================================================
    //                          RECEIVE
    // =============================================================

    receive() external payable {
        Validation.validateAmount(msg.value);

        emit ETHDeposited(msg.sender, msg.value);
    }
}
