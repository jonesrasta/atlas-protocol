// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Treasury Errors
/// @author Atlas Protocol
/// @notice Erros específicos do Treasury.

library TreasuryErrors {
    error InsufficientBalance();

    error TransferFailed();

    error InvalidToken();
}
