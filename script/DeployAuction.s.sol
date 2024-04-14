// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

import {Auction} from "../src/Auction.sol";

contract DeployAuction is Script {
    function run() external returns (Auction) {
        vm.startBroadcast();
        Auction action = new Auction();
        vm.stopBroadcast();
        return action;
    }
}
