//SPDX-License Identifier: MIT

pragma solidity ^0.8.18;

import {Script,console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{

    uint256 public constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentDeplyed) public {
        
       
        FundMe(payable(mostRecentDeplyed)).fund{value:SEND_VALUE}();
        
        console.log("Funded with %s",SEND_VALUE);

    }


    function run() external{
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }


}

contract WithdrawFundMe is Script{

}