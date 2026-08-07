// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IERC4626} from "@openzeppelin/interfaces/IERC4626.sol";

/// @title Atlas Vault Interface
/// @author Atlas Protocol
/// @notice Interface for the Atlas ERC4626 Vault.
interface IAtlasVault is IERC4626 {
    function accessManager() external view returns (address);

    function paused() external view returns (bool);

    function pause() external;

    function unpause() external;
}
