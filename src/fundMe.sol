// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {PriceContverter} from "./prcieConverter.sol";
contract FundMe{
   error notOwner();
   using  PriceContverter for uint256;
   uint256 public constant  MINIMUM_USD=3e18; 
   address[] public funders;
   mapping (address=>uint256) public addressToAmountFunded;
   function fund()public payable  {
      // allow users to send money
    //  have a  minimum $ sent

         require(msg.value.getConversionRate() > MINIMUM_USD,"did not send enough ETH");
         funders.push(msg.sender);
         addressToAmountFunded[msg.sender]+=msg.value;
   }  

   address public immutable   i_owner; 

   constructor(){
      i_owner=msg.sender;
   } 

   function withdraw()public onlyOwner {
       
      for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
         address funder=funders[funderIndex];
         addressToAmountFunded[funder]=0;
      }
      funders=new address[](0);
      // transfer
      // send
      // call
      (bool callSuccess,)=payable(msg.sender).call{value:address(this).balance}("");
      require(callSuccess,"call failed");
   }

   modifier onlyOwner(){
      // require(msg.sender==owner,"not owner)
          if (msg.sender!=i_owner){
            revert notOwner() ;
          }
      _;
   }

   receive() external payable {
      fund();
    }  

    fallback() external payable {
      fund();
     }

    

  
}