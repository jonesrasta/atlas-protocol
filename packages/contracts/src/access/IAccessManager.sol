// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

/// @title Atlas Protocol Access Manager
/// @notice Interface responsável pelo gerenciamento de permissões do protocolo.
interface IAccessManager {
    /// @notice Verifica se uma conta possui determinado papel.
    /// @param role Papel a ser verificado.
    /// @param account Conta que será verificada.
    /// @return True se a conta possuir o papel.
    function hasRole(bytes32 role, address account) external view returns (bool);

    /// @notice Concede um papel a uma conta.
    /// @param role Papel que será concedido.
    /// @param account Conta que receberá o papel.
    function grantRole(bytes32 role, address account) external;

    /// @notice Revoga um papel de uma conta.
    /// @param role Papel que será revogado.
    /// @param account Conta que perderá o papel.
    function revokeRole(bytes32 role, address account) external;
}
