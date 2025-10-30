// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";

contract BasicNftTest is Test {
    BasicNft private basicNft;
    address public constant USER = address(1);

    function setUp() public {
        basicNft = new BasicNft();
    }

    function testMintNFT() public {
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.ownerOf(0), USER);
        assertEq(basicNft.balanceOf(USER), 1);
    }

    function testTokenURI() public {
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.tokenURI(0), "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/0");
    }

    function testNameIsDogie() public view {
        assertEq(basicNft.name(), "Dogie");
    }

    function testSymbolIsDOG() public view {
        assertEq(basicNft.symbol(), "DOG");
    }

    function testMintMultipleNFTs() public {
        vm.prank(USER);
        basicNft.mintNFT();
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.balanceOf(USER), 2);
    }

    function testTokenURIForMultipleNFTs() public {
        vm.prank(USER);
        basicNft.mintNFT();
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.tokenURI(1), "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/1");

        assertEq(basicNft.tokenURI(0), "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/0");
    }

    function testRevertForNonExistentTokenURI() public {
        vm.expectRevert();
        basicNft.tokenURI(999);
    }   

    function testTokenCounterIncrement() public {
        vm.prank(USER);
        basicNft.mintNFT();
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.getTokenCounter(), 2);
    }

    function testCanMintFromDifferentAddresses() public {
        vm.prank(address(1));
        basicNft.mintNFT();
        vm.prank(address(2));
        basicNft.mintNFT();
        assertEq(basicNft.balanceOf(address(1)), 1);
        assertEq(basicNft.balanceOf(address(2)), 1);
    }   

    function testTokenURIsAreUnique() public {
        vm.prank(USER);
        basicNft.mintNFT();
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.tokenURI(0), "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/0");
        assertEq(basicNft.tokenURI(1), "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/1");
    }

    function testCanMintAndCheckOwnership() public {
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.ownerOf(0), USER);
    }

    function testCanMintAndHaveCorrectBalance() public {
        vm.prank(USER);
        basicNft.mintNFT();
        assertEq(basicNft.balanceOf(USER), 1);
    }


}