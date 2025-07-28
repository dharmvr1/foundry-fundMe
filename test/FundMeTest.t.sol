// SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinDollarIsThree() public {
        assertEq(fundMe.MINIMUM_USD(), 3e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(),address(this));
    }
}
