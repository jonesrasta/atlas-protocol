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
import "./TreasuryStorage.sol";

contract Treasury is AccessControlled, TreasuryStorage, ITreasury, ReentrancyGuard {
    using SafeERC20 for IERC20;

    constructor(address accessManager_) AccessControlled(accessManager_) {}

    function accessManager() external view override returns (address) {
        return address(_accessManager);
    }

    function depositETH() external payable override {
        Validation.validateAmount(msg.value);

        emit ETHDeposited(msg.sender, msg.value);
    }

    function withdrawETH(address payable receiver, uint256 amount)
        external
        override
        nonReentrant
        onlyRole(Roles.TREASURY_MANAGER_ROLE)
    {
        Validation.validateAddress(receiver);

        Validation.validateAmount(amount);

        uint256 balance = address(this).balance;

        if (balance < amount) {
            revert TreasuryErrors.InsufficientBalance();
        }

        _sendETH(receiver, amount);

        emit ETHWithdrawn(receiver, amount);
    }

    function _sendETH(address payable receiver, uint256 amount) internal {
        (bool success,) = receiver.call{value: amount}("");

        if (!success) {
            revert TreasuryErrors.TransferFailed();
        }
    }

    function depositToken(address token, uint256 amount) external override {
        Validation.validateAddress(token);
        Validation.validateAmount(amount);

        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

        _tokenBalances[token] += amount;

        emit TokenDeposited(token, msg.sender, amount);
    }

    function withdrawToken(address token, address receiver, uint256 amount)
        external
        override
        onlyRole(Roles.TREASURY_MANAGER_ROLE)
    {
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

    function balanceETH() external view override returns (uint256) {
        return address(this).balance;
    }

    function tokenBalance(address token) external view override returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    receive() external payable {
        emit ETHDeposited(msg.sender, msg.value);
    }
}
