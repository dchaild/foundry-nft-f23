// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {MoodNft} from "../src/MoodNft.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";


/**
 * @title DeployMoodNftTest
 * @notice This contract tests the helper functions within the DeployMoodNft script.
 */
contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testSvgToImageUri() public view {
        string memory sampleSvg = "<svg>hello</svg>";
        string memory expectedUri = "data:image/svg+xml;base64,PHN2Zz5oZWxsbzwvc3ZnPg==";
        string memory actualUri = deployer.svgToImageUri(sampleSvg);
        assertEq(actualUri, expectedUri);
    }

    function testFlipMoodFunctionality() public {
        // Deploy the MoodNft contract using the DeployMoodNft script
        MoodNft moodNft = deployer.run();

        // Mint an NFT to a test address
        address testUser = address(1);
        vm.prank(testUser);
        moodNft.mintNft();

        uint256 tokenId = 0; // Since it's the first minted token

        // Verify initial mood is HAPPY
        string memory initialTokenUri = moodNft.tokenURI(tokenId);
        assert(bytes(initialTokenUri).length > 0);

        // Flip the mood to SAD
        vm.prank(testUser);
        moodNft.flipMood(tokenId);

        // Verify mood is now SAD
        string memory flippedTokenUri = moodNft.tokenURI(tokenId);
        assert(bytes(flippedTokenUri).length > 0);
        assert(keccak256(bytes(initialTokenUri)) != keccak256(bytes(flippedTokenUri)));
    }   
}
