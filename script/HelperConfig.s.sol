// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelpConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaEthConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return SepoliaEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
