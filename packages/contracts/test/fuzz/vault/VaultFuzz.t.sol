// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {VaultBase} from "../../unit/vault/VaultBase.t.sol";

contract VaultFuzzTest is VaultBase {
    function testFuzz_deposit_roundTrip(uint256 amount) public {
        // Keep the fuzzed amount inside a safe range.
        amount = bound(amount, 1, 1_000_000 ether);

        mintAsset(user2, amount);

        vm.startPrank(user2);

        asset.approve(address(vault), amount);

        uint256 shares = vault.deposit(amount, user2);

        vm.stopPrank();

        assertGt(shares, 0);

        // Shares received must not represent more assets than
        // the amount originally deposited.
        uint256 representedAssets = vault.convertToAssets(shares);

        assertLe(representedAssets, amount);
    }

    function testFuzz_previewDeposit_matchesDeposit(uint256 amount) public {
        amount = bound(amount, 1, 1_000_000 ether);

        uint256 previewedShares = vault.previewDeposit(amount);

        mintAsset(user2, amount);

        vm.startPrank(user2);

        asset.approve(address(vault), amount);

        uint256 actualShares = vault.deposit(amount, user2);

        vm.stopPrank();

        assertEq(actualShares, previewedShares);
    }

    function testFuzz_previewMint_matchesMint(uint256 shares) public {
        shares = bound(shares, 1, 1_000_000 ether);

        uint256 previewedAssets = vault.previewMint(shares);

        mintAsset(user2, previewedAssets);

        vm.startPrank(user2);

        asset.approve(address(vault), previewedAssets);

        uint256 actualAssets = vault.mint(shares, user2);

        vm.stopPrank();

        assertEq(actualAssets, previewedAssets);
        assertEq(vault.balanceOf(user2), shares);
    }

    function testFuzz_donation_doesNotMintShares(uint256 donation) public {
        donation = bound(donation, 1, 1_000_000 ether);

        uint256 supplyBefore = vault.totalSupply();
        uint256 assetsBefore = vault.totalAssets();

        mintAsset(address(vault), donation);

        assertEq(vault.totalSupply(), supplyBefore);
        assertEq(vault.totalAssets(), assetsBefore + donation);
    }

    function testFuzz_convertToShares_neverExceedsAssets(uint256 assets) public view {
        assets = bound(assets, 1, 1_000_000 ether);

        uint256 shares = vault.convertToShares(assets);

        assertLe(shares, assets);
    }

    function testFuzz_previewDeposit_matchesConvertToShares(uint256 assets) public view {
        assets = bound(assets, 1, 1_000_000 ether);

        assertEq(vault.previewDeposit(assets), vault.convertToShares(assets));
    }
}

