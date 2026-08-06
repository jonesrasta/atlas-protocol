// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

/// @title MockERC20
/// @author Atlas Protocol
/// @notice ERC20 utilizado exclusivamente para testes do Treasury.
contract MockERC20 is ERC20 {
    constructor() ERC20("Mock Token", "MOCK") {}

    /// @notice Cunha tokens para qualquer endereço.
    /// @param to Destinatário dos tokens.
    /// @param amount Quantidade a ser cunhada.
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }

    /// @notice Queima tokens de qualquer endereço.
    /// @param from Endereço que terá os tokens queimados.
    /// @param amount Quantidade a ser queimada.
    function burn(address from, uint256 amount) external {
        _burn(from, amount);
    }
}
