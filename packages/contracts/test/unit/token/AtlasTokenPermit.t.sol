// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AtlasTokenBaseTest} from "./AtlasTokenBase.t.sol";

contract AtlasTokenPermitTest is AtlasTokenBaseTest {
    bytes32 internal constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    //BASIC TESTS

    function testInitialNonceIsZero() public view {
        assertEq(atlasToken.nonces(user), 0);
    }

    function testDomainSeparatorIsInitialized() public view {
        assertTrue(atlasToken.DOMAIN_SEPARATOR() != bytes32(0));
    }

    function testInitialAllowanceIsZero() public view {
        assertEq(atlasToken.allowance(user, spender), 0);
    }

    //SUCCESS CASES

    function testPermitSuccess() public {
        uint256 value = 500 ether;

        _executePermit(value, block.timestamp + 1 days);

        assertEq(atlasToken.allowance(user, spender), value);

        assertEq(atlasToken.nonces(user), 1);
    }

    function testPermitUpdatesAllowance() public {
        uint256 value = 250 ether;

        _executePermit(value, block.timestamp + 1 days);

        assertEq(atlasToken.allowance(user, spender), value);
    }

    function testPermitIncrementsNonce() public {
        assertEq(atlasToken.nonces(user), 0);

        _executePermit(100 ether, block.timestamp + 1 days);

        assertEq(atlasToken.nonces(user), 1);
    }

    //SECURITY TESTS

    function testPermitExpiredDeadline() public {
        uint256 value = 100 ether;

        uint256 deadline = block.timestamp - 1;

        (uint8 v, bytes32 r, bytes32 s) = _signPermit(value, deadline, userPrivateKey);

        vm.expectRevert();

        atlasToken.permit(user, spender, value, deadline, v, r, s);
    }

    function testPermitInvalidSignature() public {
        uint256 value = 100 ether;

        uint256 deadline = block.timestamp + 1 days;

        (uint8 v, bytes32 r, bytes32 s) = _signPermit(value, deadline, attackerPrivateKey);

        vm.expectRevert();

        atlasToken.permit(user, spender, value, deadline, v, r, s);
    }

    function testPermitReplayAttack() public {
        uint256 value = 100 ether;

        uint256 deadline = block.timestamp + 1 days;

        (uint8 v, bytes32 r, bytes32 s) = _signPermit(value, deadline, userPrivateKey);

        // Primeira execução

        atlasToken.permit(user, spender, value, deadline, v, r, s);

        assertEq(atlasToken.nonces(user), 1);

        // Replay usando mesma assinatura

        vm.expectRevert();

        atlasToken.permit(user, spender, value, deadline, v, r, s);
    }

    //HELPERS

    function _executePermit(uint256 value, uint256 deadline) internal {
        (uint8 v, bytes32 r, bytes32 s) = _signPermit(value, deadline, userPrivateKey);

        atlasToken.permit(user, spender, value, deadline, v, r, s);
    }

    function _signPermit(uint256 value, uint256 deadline, uint256 privateKey)
        internal
        view
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        bytes32 digest = _getPermitDigest(user, spender, value, atlasToken.nonces(user), deadline);

        (v, r, s) = vm.sign(privateKey, digest);
    }

    function _getPermitDigest(address owner, address spender_, uint256 value, uint256 nonce, uint256 deadline)
        internal
        view
        returns (bytes32)
    {
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender_, value, nonce, deadline));

        return keccak256(abi.encodePacked("\x19\x01", atlasToken.DOMAIN_SEPARATOR(), structHash));
    }
}
