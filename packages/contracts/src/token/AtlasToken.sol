// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {IAccessManager} from "../access/IAccessManager.sol";
import {Roles} from "../access/Roles.sol";

import {AtlasTokenBase} from "./AtlasTokenBase.sol";
import {AtlasTokenStorage} from "./AtlasTokenStorage.sol";
import {IAtlasToken} from "./IAtlasToken.sol";

import {Unauthorized, ZeroAddress, InvalidAmount} from "./TokenErrors.sol";

import "./TokenEvents.sol";

/// @title AtlasToken
/// @notice Token principal do Atlas Protocol.
contract AtlasToken is AtlasTokenBase, AtlasTokenStorage, IAtlasToken {
    constructor(address accessManager_) AtlasTokenBase("Atlas Token", "ATLAS") {
        if (accessManager_ == address(0)) {
            revert ZeroAddress();
        }

        _accessManager = accessManager_;
    }

    /**
     * @notice Retorna o AccessManager responsável pelas permissões.
     */
    function accessManager() external view override returns (address) {
        return _accessManager;
    }

    /**
     * @notice Verifica se o usuário possui uma role.
     */
    modifier onlyRole(bytes32 role) {
        if (!IAccessManager(_accessManager).hasRole(role, msg.sender)) {
            revert Unauthorized();
        }

        _;
    }

    /**
     * @notice Cria novos tokens.
     * @param to Endereço que receberá os tokens.
     * @param amount Quantidade criada.
     */
    function mint(
        address to,
        uint256 amount
    ) external override onlyRole(Roles.MINTER_ROLE) {
        _validateAddress(to);

        _validateAmount(amount);

        _mint(to, amount);

        emit Mint(to, amount);
    }

    /**
     * @notice Remove tokens de um endereço.
     * @param from Endereço que perderá os tokens.
     * @param amount Quantidade removida.
     */
    function burn(
        address from,
        uint256 amount
    ) external override onlyRole(Roles.BURNER_ROLE) {
        _validateAddress(from);

        _validateAmount(amount);

        _burn(from, amount);

        emit Burn(from, amount);
    }

    /**
     * @notice Valida endereço.
     */
    function _validateAddress(address account) internal pure {
        if (account == address(0)) {
            revert ZeroAddress();
        }
    }

    /**
     * @notice Valida quantidade.
     */
    function _validateAmount(uint256 amount) internal pure {
        if (amount == 0) {
            revert InvalidAmount();
        }
    }
}
