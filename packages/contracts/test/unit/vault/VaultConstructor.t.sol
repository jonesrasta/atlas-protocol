// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {VaultBase} from "./VaultBase.t.sol";

contract VaultConstructorTest is VaultBase {
    function test_constructor_setsAsset() public view {
        assertEq(address(vault.asset()), address(asset));
    }

    function test_constructor_setsVaultName() public view {
        assertEq(vault.name(), "Atlas Vault Share");
    }

    function test_constructor_setsVaultSymbol() public view {
        assertEq(vault.symbol(), "aATLAS");
    }

    function test_constructor_setsAccessManager() public view {
        assertEq(vault.accessManager(), address(accessManager));
    }
}
