// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/token/ERC20/extensions/ERC20Votes.sol";
import {Nonces} from "@openzeppelin/utils/Nonces.sol";

/// @title AtlasTokenBase
/// @notice Camada base que integra os contratos OpenZeppelin.
abstract contract AtlasTokenBase is ERC20, ERC20Permit, ERC20Votes {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) ERC20Permit(name_) {}

    function _update(address from, address to, uint256 value) internal virtual override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    function nonces(address owner) public view virtual override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }
}
