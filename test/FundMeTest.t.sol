// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant INT_BAL = 10 ether;
    uint256 constant SEDN_FUND = 4e18;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, INT_BAL);
    }

    //  unit test :testing a single part;  below exm;
    function testMinDollarIsThree() public {
        assertEq(fundMe.MINIMUM_USD(), 3e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    //    integration test  (below getversion from other contract)
    function testVersionPriceFeed() public {
        uint256 verison = fundMe.getVersion();
        assertEq(verison, 4);
    }

    function testFundFailNotHaveEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEDN_FUND}();
        uint256 amountFunded = fundMe.gettAddressToAmountFunded(USER);
        assertEq(amountFunded, SEDN_FUND);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEDN_FUND}();
        address funder = fundMe.getFunders(0);

        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEDN_FUND}();
        _;
    }

    function TestOnlyOwnerWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    // Forked  Test
    function testwithDrawwithSingleFunder() public funded {
        // arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // act
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // assert
        uint256 gasStart = gasleft();
        uint256 endingOwnerBalence = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        uint256 gasEnd = gasleft();

        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
       
        console.log(gasUsed);

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalence
        );
    }

    function testwithDrawwithMultipleFunder() public funded {
        uint160 numberOfFunders = 10;
        uint160 startFunderIndex = 1;

        for (uint160 i = startFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEDN_FUND);
            fundMe.fund{value: SEDN_FUND}();
        }

        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        assert(address(fundMe).balance == 0);
        assert(
            startFundMeBalance + startOwnerBalance == fundMe.getOwner().balance
        );
    }
    // staging Test
}
