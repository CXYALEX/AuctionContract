// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
import {Math} from "./CryptoLib/math.sol";

contract Auction {
    // State variables
    mapping(uint256 => bytes) public s_pkcList; // store the public key of the commitee parties
    mapping(uint256 => AuctionTx) public s_transactionList; //auction party pid => auction tx
    bytes public s_g;
    bytes public s_h;
    bytes public s_q;
    bytes public s_p;
    uint256 public s_commiteeCount;
    uint256 public s_winerbid;
    uint256 public s_winerid;

    struct AuctionTx {
        uint256 id;
        uint256 value;
    }

    constructor() {}

    function setpkcList(uint256 index, bytes memory pk) public {
        if (s_pkcList[index].length == 0) s_commiteeCount++;

        s_pkcList[index] = pk;
    }

    function setGenerator(bytes memory g, bytes memory h) public {
        s_g = g;
        s_h = h;
    }

    function setPrime(bytes memory p, bytes memory q) public {
        s_p = p;
        s_q = q;
    }

    function getWinnerInfo() public view returns (uint256, uint256) {
        return (s_winerid, s_winerbid);
    }

    function getPrime() public view returns (bytes memory, bytes memory) {
        return (s_p, s_q);
    }

    function getParam()
        public
        view
        returns (bytes memory, bytes memory, bytes[] memory)
    {
        uint256 len = s_commiteeCount + 1;
        bytes[] memory pkclist = new bytes[](len);
        for (uint256 i = 0; i < len; i++) {
            pkclist[i] = s_pkcList[i];
        }

        return (s_g, s_h, pkclist);
    }

    function getGenerator() public view returns (bytes memory) {
        return s_g;
    }

    function getCommiteeCount() public view returns (uint256) {
        return s_commiteeCount;
    }

    // store pedersen commitment on chain
    function setup(uint256 pid, uint256 id, uint256 value) public {
        s_transactionList[pid] = AuctionTx(id, value);
    }

    //open the commitment after anonymous veto
    function openCommitment(
        uint256 pid, // auction party id
        uint256 value, //bid
        uint256 r
    ) public {
        // open commitment
        uint256 g = Math.bytesToUint(s_g);
        uint256 p = Math.bytesToUint(s_p);
        uint256 h = Math.bytesToUint(s_h);
        uint256 lhs = ((Math.pow_mod(g, value, p) * Math.pow_mod(h, r, p)) % p);
        uint256 c = s_transactionList[pid].value;
        uint256 rhs = c % p;

        require(lhs == rhs);
        s_winerid = pid;
        s_winerbid = value;
    }
}
