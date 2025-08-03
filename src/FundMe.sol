// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {PriceConverter} from "../src/PriceConverter.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FUNDME__NOTOWNER();

contract FundMe {
    using PriceConverter for uint256;

    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    //pricefeed 0x694AA1769357215DE4FAC081bf1f309aDC325306 for sepolia chain

    uint256 public constant MINIMUM_USD = 5e18;
    address[] private s_funderlist;
    mapping(address => uint256) private s_addresstoamtfunded;

    function getVersion() public view returns (uint256) {
        return PriceConverter.getversion(s_priceFeed); //variable independent functions cant be called without the library name like so.
    }

    function fund() public payable {
        require(
            msg.value.getConvertedPrice(s_priceFeed) > MINIMUM_USD,
            " Not Enough ETH "
        );
        //require(getConvertedPrice(msg.value) > minimumUSD);
        s_funderlist.push(msg.sender);
        s_addresstoamtfunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        //require(msg.sender == owner , "NOT OWNER");
        uint256 flength = s_funderlist.length;
        for (uint256 i = 0; i < flength; i++) {
            s_addresstoamtfunded[s_funderlist[i]] = 0;
        }
        //address funderlist = new address[](0);
        //bytes memory dataReturned we dont really care about the dataReturned.
        (bool callsuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        //call makes a state change
        //value when passing this. balance passes entire balance to the payable address msg.sender as value
        //empty "" means we pass empty data field
        require(callsuccess, "Transaction failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FUNDME__NOTOWNER();
        }
        _;
    }

    //getter functions:

    function getAddressToAmtFunded(
        address addressofcaller
    ) external view returns (uint256) {
        return s_addresstoamtfunded[addressofcaller];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funderlist[index];
    }

    function getOwner() external view returns(address){
        return i_owner;
    }
}
