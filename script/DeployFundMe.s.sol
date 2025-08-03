// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    FundMe fundme;

    function run() external returns (FundMe) {
        //another before broadcast doesnot count as a real txn
        HelperConfig helperConfig = new HelperConfig();
        vm.startBroadcast();
        fundme = new FundMe(helperConfig.activeNetworkConfig()); // we are basically checking the chain id and passing the priceFeed address
        vm.stopBroadcast();
        return fundme;
    }
}
