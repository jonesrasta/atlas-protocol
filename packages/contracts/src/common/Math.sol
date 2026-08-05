// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

library Math {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function percentage(uint256 amount, uint256 basisPoints) internal pure returns (uint256) {
        return (amount * basisPoints) / 10_000;
    }
}
