// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script, console} from "lib/forge-std/src/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "src/FundMe.sol";

contract FUNDfundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function FFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}(); //向指定的 FundMe 合约发送 SEND_VALUE 数量的 ETH。
        vm.stopBroadcast();
        console.log("Funded fundFundMe $", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundeMe",
            block.chainid
        );
        vm.startBroadcast();
        FFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast;
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundeMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast;
    }
}
