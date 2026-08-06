// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @notice Thrown when the vault is already paused.
error AlreadyPaused();

/// @notice Thrown when the vault is not paused.
error NotPaused();

/// @notice Thrown when an operation is attempted while the vault is paused.
error VaultIsPaused();
