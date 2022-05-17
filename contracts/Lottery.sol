// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Lottery {
    address payable[] public players;
    uint256 public usdEntryFee;

    constructor() public {
        usdEntryFee = 50 * (10**18);
    }

    function enter() public payable {
        //push the address of the sender
        players.push(msg.sender);
    }

    function getEntranceFee() public view returns (uint256) {
        (,int256 price, ,,,) = ethUsdPriceFeed.latestRoundData;
        uint256 adjustPrice = uint256(price) * 10**10;
        uint256 costToEnter = (usdEntryFee *10**18) / price;
        return costToEnter;
    }

    function startLottery() public {}

    function endLottery() public {}
}
