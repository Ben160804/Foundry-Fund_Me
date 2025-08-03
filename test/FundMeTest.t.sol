//SPDX-License-Identifier : MIT
pragma solidity ^0.8.18;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    //uint256 number = 1;
    FundMe fundme; // global declaration as we need it in all the tests
    DeployFundMe deployfundme; // need to create a new deployFundMe instance to access its functions.
    //pranking , setting up a designated user for our tests
    address USER = makeAddr("user");


    

    

    //all tests start with this function
    function setUp() external {
        deployfundme = new DeployFundMe();
        fundme = deployfundme.run(); // run now returns a fundme contract.
        vm.deal(USER,10 ether); // gives the user a starting balance of the specified amount.
    }

    //to make tests more lazy :) use modifiers
    modifier funded() {
        vm.prank(USER);
        fundme.fund{value:1e18}();
        _;
    }

    function testMinimumDollarIs5() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
        //console.log(number);
        //assertEq(number,2);
    }

    function testmsgsenderisowner() public view {
        //console.log(fundme.i_owner()); for some reason linter cant recognize the path console is in
        //assertEq(fundme.i_owner(),msg.sender); //this would fail because the owner is FundMeTest and msg.sender is address calling the test
        //assertEq(fundme.i_owner(), address(this)); // this passes as the FundMeTest becomes the owner of this contract.
        assertEq(fundme.getOwner(), msg.sender); // this woorks after refactoring our code due to the magical startBroadcast due to that being present the contract is no more the owner its the testrunner or the deployer thats the owner
    }

    /*Types of tests:
    Unit: testing a very specific part of our code

    Integration: testing how our code works with other parts of the code

    Forked: Testing in a simulated real environment

    Staging: Testing in a real environment thats not prod
    */

    function testVersion() public view {
        uint256 version = fundme.getVersion(); //make sure this library function is exposed in the actual contract
        //console.log(version);
        assertEq(version, 4);
    }

    function testTxnFailsWithoutEnoughEth() public {
        vm.expectRevert(); // next transaction MUST REVERT otherwise test will fail
        fundme.fund{value: 0.001 ether}();
    }

    function testFundUpdatesTheMapping() public {
        vm.prank(USER); //next transaction will be sent by the user address we got using makeAddr
        fundme.fund{value: 1e18}();
        //uint256 amountFunded = fundme.getAddressToAmtFunded(address(this)); // when ever we are reusing a deployed script and using vmbroadcast the tests are run by the test contract address, pranking is another way to ensure no hiccups
        uint256 amountFunded = fundme.getAddressToAmtFunded(USER);
        assertEq(amountFunded , 1e18);
    }

    function testFunderAddedToFunderList() public funded {
        address funder = fundme.getFunder(0);
        assertEq(funder,USER);
    }

    function testOnlyOwnerCanWithdraw() public funded{
        //console.log("Owner is: ", fundme.i_owner());
        //console.log("This address: ", msg.sender);
        /*vm.prank(msg.sender);
        //vm.expectRevert();
        fundme.withdraw();*/ //to check the owner can withdraw
        vm.prank(USER); //only the owner can withdraw
        vm.expectRevert();
        fundme.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded{
        //Arrange
        uint256 starting_owner_balance = fundme.getOwner().balance;
        uint256 starting_fundme_balance = address(fundme).balance;

        //Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        //assert
        uint256 endingOwnerbalance = fundme.getOwner().balance;
        uint256 ending_fund_me_balance = address(fundme).balance;
        assertEq(ending_fund_me_balance , 0);
        assertEq(starting_fundme_balance + starting_owner_balance , endingOwnerbalance);


    }

    function testWithdrawFromMultipleFunders() public {
        uint160 nofunders = 10;
        
        for (uint160 funder = 1;funder < nofunders ; funder++){
            //instead of pranking and dealing we can use std-lib function hoax(address,value)
            hoax(address(funder),1e18);
            fundme.fund{value:1e18}();

        }

        uint256 starting_fundme_balance = address(fundme).balance;
        uint256 starting_owner_balance = fundme.getOwner().balance;
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        uint256 endingOwnerbalance = fundme.getOwner().balance;
        uint256 ending_fund_me_balance = address(fundme).balance;
        assertEq(ending_fund_me_balance , 0);
        assertEq(starting_fundme_balance + starting_owner_balance , endingOwnerbalance);
    }

}
