// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

contract HelperConfig is Script {
    networkConfig public activeNetwork;
    uint8 public constant DECIMALS=8;
    int256 public constant INITIAL_PRICE=2000e8;

    struct networkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else {
            activeNetwork = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (networkConfig memory) {
        networkConfig memory sepliaConfig = networkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepliaConfig;
    }

    function getOrCreateAnvilEthConfig() public  returns (networkConfig memory) {
       
       if(activeNetwork.priceFeed != address(0)){
        return activeNetwork;
       }
 

        vm.startBroadcast();
        MockV3Aggregator  mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        networkConfig memory anvilConfig = networkConfig({priceFeed :address(mockPriceFeed)});

        return anvilConfig;
    }
}

// contract HelPerConfig is Script {
//     networkConfig public activeNetwork;

//     struct networkConfig {
//         address priceFeed;
//     }

//     constructor() {
//         if (block.chainid == 11155111) {
//             activeNetwork = getSepEth();
//         } else {
//             activeNetwork = getAnvilEth();
//         }
//     }

//     function getSepEth() public pure returns (networkConfig memory) {
//         networkConfig memory sepoliaEth = networkConfig({
//             priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
//         });
//         return sepoliaEth;
//     }
//     function getAnvilEth() public pure returns(networkConfig memory) {

//     }
// }
