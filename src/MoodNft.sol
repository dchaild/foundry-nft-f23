// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from  "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";


contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    error MoodNft_CantFlipMoodIfNotOwner();

    constructor(string memory happySvgUri, string memory sadSvgUri) ERC721("MoodNft", "MNFT")    {
        
        s_tokenCounter = 0;
        s_happySvgImageUri = happySvgUri;
        s_sadSvgImageUri = sadSvgUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // _checkAuthorized will revert if the token doesn't exist or if msg.sender is not the owner or approved.
        address owner = ownerOf(tokenId);
        _checkAuthorized(owner, msg.sender, tokenId);

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        // return base URI which is : data:image/svg+xml;base64, when we are using base64 encoding for svg images
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {

        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }
        // For simplicity, all tokens use the happy SVG image URI
        
        return string(
            abi.encodePacked(
                // Concatenate the base URI with the Base64-encoded JSON metadata
                _baseURI(),
                // Encode the JSON metadata in Base64
                // JSON metadata includes name, description, attributes, and image URI
                // we use abi.encodePacked to concatenate strings
                // then we convert it to bytes and finally we encode it to base64
                Base64.encode (bytes (abi.encodePacked(
                    '{"name": "', name(),
                    '", "description": "An NFT that reflects mood.", "attributes": [{"trait_type":"moodiness", "value": 100}], "image": "',
                    imageURI,
                    '"}'
                ))
            )
        ));

      }
    
    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function getHappySvg() public view returns (string memory) {
        return s_happySvgImageUri;
    }

    function getSadSvg() public view returns (string memory) {
        return s_sadSvgImageUri;
    }
}