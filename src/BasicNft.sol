// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_baseTokenURI;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
        s_baseTokenURI = "ipfs://QmQPEMsfd1tJnqYPbnTQCjoa8vczfsV1FmqZWgC381ausa/";
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function _baseURI() internal view override returns (string memory) {
        return s_baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        // This will call the parent ERC721's tokenURI function, which combines _baseURI and tokenId.
        return super.tokenURI(tokenId);
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
