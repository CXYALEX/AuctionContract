// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Auction} from "../src/Auction.sol";

contract setGeneratorAuction is Script {
    bytes public constant G_CONSTANT = hex"0145";
    bytes public constant H_CONSTANT = hex"0156";
    bytes public constant P_CONSTANT = hex"0156";
    bytes public constant Q_CONSTANT = hex"0156";

    function _setGenerator(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        Auction(payable(mostRecentlyDeployed)).setGenerator(
            G_CONSTANT,
            H_CONSTANT
        );
        vm.stopBroadcast();
        console.log("setGeneratorAuction");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Auction",
            block.chainid
        );
        _setGenerator(mostRecentlyDeployed);
    }
}

contract getGeneratorAuction is Script {
    function _getGenerator(address mostRecentlyDeployed) public view {
        //vm.startBroadcast();
        bytes memory g = Auction(payable(mostRecentlyDeployed)).getGenerator();
        //vm.stopBroadcast();
        console.log(string(g));
    }

    function run() external view {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Auction",
            block.chainid
        );
        _getGenerator(mostRecentlyDeployed);
    }
}

contract getParam is Script {
    function _getGenerator(address mostRecentlyDeployed) public view {
        //vm.startBroadcast();
        bytes memory s_g;
        bytes memory s_h;
        bytes[] memory pkclist;
        (s_g, s_h, pkclist) = Auction(payable(mostRecentlyDeployed)).getParam();
        //vm.stopBroadcast();
        console.log(string(s_g));
        console.log(string(s_h));
        console.log(string(pkclist[0]));
        console.log(string(pkclist[1]));
        console.log(string(pkclist[2]));
    }

    function run() external view {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Auction",
            block.chainid
        );
        _getGenerator(mostRecentlyDeployed);
    }
}
