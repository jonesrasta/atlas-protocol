// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AtlasTokenBaseTest} from "./AtlasTokenBase.t.sol";

contract AtlasTokenPermitTest is AtlasTokenBaseTest {
    function testInitialNonceIsZero() public view {
        assertEq(atlasToken.nonces(user), 0);
    }

    function testDomainSeparatorIsInitialized() public view {
        assertTrue(atlasToken.DOMAIN_SEPARATOR() != bytes32(0));
    }

    function testInitialAllowanceIsZero() public view {
        assertEq(atlasToken.allowance(user, spender), 0);
    }
}
