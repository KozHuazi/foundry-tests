// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelpConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelpConfig helpConfig = new HelpConfig();
        address ethUsdPriceFeed = helpConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
