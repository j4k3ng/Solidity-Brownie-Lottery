// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract Lottery {
    address payable[] internal players;
    uint256 internal usdEntryFee;
    AggregatorV3Interface internal ethUsdPriceFeed;
    bool internal isRunning;
    address internal owner;

    constructor(address _priceFeedAddress) public {
        usdEntryFee = 1; 
        ethUsdPriceFeed = AggregatorV3Interface(_priceFeedAddress);
        isRunning = true;
        owner = msg.sender;
    }

    modifier onlyOwnerOnce() {
        require(msg.sender == owner && isRunning == true);
        _;
    }

    function retrieveEthPrice() public view returns (uint256) {
        (, int256 price,,,) = ethUsdPriceFeed.latestRoundData();
        return uint256(price);
    } 

    function enter() public payable {
        //push the address of the sender
        require(isRunning == true, "the lottery is closed" );
        uint256 ethUsdPrice = retrieveEthPrice();
        uint256 weiRequired = 10**18 * 10**9 * usdEntryFee / ethUsdPrice;  // first I multiply for 10**9 because the denomitore is in gwei, then the result is in eth so I need to multiply to 10**18 to get the corrispondent wei.
        require(msg.value >= weiRequired, "not enough founds, minimum required is 50 usd" );
        players.push(msg.sender);
    }


    // function getEntranceFee() public view returns (uint256) {
    //     (,int256 price,,,) = ethUsdPriceFeed.latestRoundData;
    //     uint256 adjustPrice = uint256(price) * 10**10;
    //     uint256 costToEnter = (usdEntryFee *10**18) / price;
    //     return costToEnter;
    // }

    // function startLottery() public {}


    function endLottery() public onlyOwnerOnce {
        isRunning = false;
    }
}
