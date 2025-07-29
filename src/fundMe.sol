// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {PriceContverter} from "./prcieConverter.sol";
import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    error FundMe__notOwner();
    using PriceContverter for uint256;
    uint256 public constant MINIMUM_USD = 3e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;

    function fund() public payable {
        // allow users to send money
        //  have a  minimum $ sent

        require(
            msg.value.getConversionRate(s_priceFeed) > MINIMUM_USD,
            "did not send e ETH"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }
    
   
     
    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // transfer
        // send
        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        // require(msg.sender==owner,"not owner)
        if (msg.sender != i_owner) {
            revert FundMe__notOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function gettAddressToAmountFunded(
        address fundingAddress
    ) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 index) external view returns (address) {
      return s_funders[index];
    }

    function getOwner() external view returns(address) {
      return i_owner;

    }
}
