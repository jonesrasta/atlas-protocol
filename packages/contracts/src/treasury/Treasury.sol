// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

import "../access/Roles.sol";
import "../common/AccessControlled.sol";
import "../common/Validation.sol";

import "./ITreasury.sol";
import "./TreasuryErrors.sol";
import "./TreasuryEvents.sol";
import "./TreasuryStorage.sol";

/// @title Treasury
/// @author Atlas Protocol
/// @notice Treasury responsável pela custódia dos ativos do protocolo.
contract Treasury is AccessControlled, TreasuryStorage, ITreasury {
    using SafeERC20 for IERC20;

    constructor(address accessManager_)
        AccessControlled(accessManager_)
    {}

    /// @inheritdoc ITreasury
    function accessManager() external view override returns (address) {
        return address(_accessManager);
    }

    /// @inheritdoc ITreasury
    function depositETH() external payable override {
        Validation.validateAmount(msg.value);

        emit ETHDeposited(msg.sender, msg.value);
    }

    /// @inheritdoc ITreasury
    function withdrawETH(
        address payable receiver,
        uint256 amount
    ) external override onlyRole(Roles.TREASURY_MANAGER_ROLE) {
        Validation.validateAddress(receiver);
        Validation.validateAmount(amount);

        if (address(this).balance < amount) {
            revert TreasuryErrors.InsufficientBalance();
        }

        (bool success,) = receiver.call{value: amount}("");

        if (!success) {
            revert TreasuryErrors.TransferFailed();
        }

        emit ETHWithdrawn(receiver, amount);
    }

    /// @inheritdoc ITreasury
    function depositToken(
        address token,
        uint256 amount
    ) external override {
        Validation.validateAddress(token);
        Validation.validateAmount(amount);

        IERC20(token).safeTransferFrom(
            msg.sender,
            address(this),
            amount
        );

        _tokenBalances[token] += amount;

        emit TokenDeposited(token, msg.sender, amount);
    }

    /// @inheritdoc ITreasury
    function withdrawToken(
        address token,
        address receiver,
        uint256 amount
    ) external override onlyRole(Roles.TREASURY_MANAGER_ROLE) {
        Validation.validateAddress(token);
        Validation.validateAddress(receiver);
        Validation.validateAmount(amount);

        if (_tokenBalances[token] < amount) {
            revert TreasuryErrors.InsufficientBalance();
        }

        _tokenBalances[token] -= amount;

        IERC20(token).safeTransfer(receiver, amount);

        emit TokenWithdrawn(token, receiver, amount);
    }

    /// @inheritdoc ITreasury
    function balanceETH() external view override returns (uint256) {
        return address(this).balance;
    }

    /// @inheritdoc ITreasury
    function tokenBalance(
        address token
    ) external view override returns (uint256) {
        return _tokenBalances[token];
    }

    receive() external payable {
        emit ETHDeposited(msg.sender, msg.value);
    }
}
