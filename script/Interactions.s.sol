// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://QmYt4g9G6X3rVNpWyy3Z2y7Kx1U5pV8Dq3f5c6Z5b6Z5b6";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BasicNft", block.chainid
        );
        mintNftOnContract(mostRecentlyDeployed);
    }
    
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNFT(); // Corrected: matches case and no arguments
        vm.stopBroadcast();
    }

    function getPUG() public pure returns (string memory) {
        return PUG;
    }
}   