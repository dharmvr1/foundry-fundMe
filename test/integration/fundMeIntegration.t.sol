// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interactiono.s.sol";

contract FundMeTestInteraction is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant INT_BAL = 10 ether;
    uint256 constant SEDN_FUND = 4e18;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();

        FundMe fundMe = deploy.run();

        vm.deal(USER, INT_BAL);
    }

    function testUserCanFundandWithdraw() public {
        uint256 preUserBalance = address(USER).balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;
        uint256 originalFundMeBalance = address(fundMe).balance;

        // Using vm.prank to simulate funding from the USER address
        vm.prank(USER);
        fundMe.fund{value: SEDN_FUND}();
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
