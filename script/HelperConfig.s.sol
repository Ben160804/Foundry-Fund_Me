//Deploy a mock when on local anvil chain
//Keep track of different addresses across different chains

//SPDX-License-Identifier = MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    MockV3Aggregator public mockv3aggregator;
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant STARTING_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    // we create a memory data type as we need a temporary function scoped struct , copy of which gets returned so using meory is most viable
    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaEthConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaEthConfig;
    }

    //pure functions dont deploy anything or change the state of blockchain
    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetEthConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetEthConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        mockv3aggregator = new MockV3Aggregator(DECIMALS, STARTING_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilEthConfig = NetworkConfig({priceFeed: address(mockv3aggregator)});

        return anvilEthConfig;
    }
}
