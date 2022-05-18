// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Lottery {
    address payable[] public players;
    uint256 public usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 1; 
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    function retrieveEntryCondition() public payable {
        uint256 ethUsdPrice = retrieveEthPrice();
        uint256 weiRequired = 10**18 * 10**9 * usdEntryFee / ethUsdPrice;  // first I multiply for 10**9 because the denomitore is in gwei, then the result is in eth so I need to multiply to 10**18 to get the corrispondent wei.
        require(msg.value >= weiRequired,"not enough founds, minimum required is 50 usd" );
    }

    function retrieveEthPrice() public view returns (uint256) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = ethUsdPriceFeed.latestRoundData();
        return uint256(answer);
    } 

    function enter() public payable {
        //push the address of the sender
        // require(50/getConversionRate(msg.value)>= minimum, "you need at least 50 usd");
        players.push(msg.sender);
    }


    // function getEntranceFee() public view returns (uint256) {
    //     (,int256 price,,,) = ethUsdPriceFeed.latestRoundData;
    //     uint256 adjustPrice = uint256(price) * 10**10;
    //     uint256 costToEnter = (usdEntryFee *10**18) / price;
    //     return costToEnter;
    // }

    function startLottery() public {}

    function endLottery() public {}
}
