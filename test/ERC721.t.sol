// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/ERC721.sol";

contract ERC721Test is Test {
    ERC721 public erc721;
    // create 2 new wallet we can use for testing
    address bob  = address(0x1);
    address alice  = address(0x2);

    // Mint a single token and check if the owner is bob
    function testMintToken() public {
        erc721 = new ERC721();
        erc721._mint(bob, 0);
        address owner_of = erc721.ownerOf(0);
        assertEq(bob, owner_of);
    }

    // Mint 1 token token[0] to bob and 1 to alice token[1]
    function testTransferToken() public {
        erc721 = new ERC721();
        erc721._mint(bob, 0);
        erc721._mint(alice, 1);

        // startPrank lets us interact as bob
        vm.startPrank(bob);
        // Transfer a token[0] from bob to alice 
        erc721.safeTransferFrom(bob, alice, 0);
        // checks alice is the owner of token[0]
        address owner_of = erc721.ownerOf(0);
        assertEq(alice, owner_of);
        // Stop interacting as bob
        vm.stopPrank();

        // startPrank lets us interact as alice
        vm.startPrank(alice);
        // Transfer a token[1] from alice to bob
        erc721.safeTransferFrom(alice, bob, 0);
        // checks bob is the owner of token[1]
        address owner_of1 = erc721.ownerOf(1);
        assertEq(alice, owner_of1);
    }

    function testGetBalanceOf() public {
        erc721 = new ERC721();
        // mint 5 different tokens
        erc721._mint(bob, 0);
        erc721._mint(bob, 1);
        erc721._mint(bob, 2);
        erc721._mint(bob, 3);
        erc721._mint(bob, 4);

        // checks to see how many tokens bob owns
        uint balance = erc721.balanceOf(bob);
        console.log("bobs token blance is:", balance);
        assertEq(balance, 5);
    }

    function testOnlyOwnerBurn() public {
        erc721 = new ERC721();
        erc721._mint(bob, 0);
        vm.startPrank(bob);
        // burn token[0]
        erc721._burn(0);
    }
}
