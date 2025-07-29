// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceContverter{

   function getPrice(AggregatorV3Interface priceFeed) internal  view  returns (uint256) {
    
    // Addresss sepolliatestnet  0x694AA1769357215DE4FAC081bf1f309aDC325306 
    // Addresss zksync sepolliatestnet 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
    (,int256 price,,,)=priceFeed.latestRoundData();
    return uint256(price*1e10);
   } 
   function getConversionRate(uint256 ethAmount ,AggregatorV3Interface priceFeed) internal  view returns (uint256) {
     uint256 ethPrice= getPrice(priceFeed);
     uint256 ethAmountInUsd=(ethPrice*ethAmount)/1e18;
     return ethAmountInUsd;


   } 
   
}