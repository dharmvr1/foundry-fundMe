// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/fundMe.sol";
import {HelperConfig} from "./helperConfig.s.sol";
contract DeployFundMe is Script {
    

    function run() external returns(FundMe) {
        HelperConfig HelperConfig = new HelperConfig();
        (address ethUsdPrice)= HelperConfig.activeNetwork();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPrice);
        vm.stopBroadcast();
        return fundMe;
    }


}
