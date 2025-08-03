//SPDX-License-Converter: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//
library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        //AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer,,,) = AggregatorV3Interface(priceFeed).latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConvertedPrice(uint256 ethamt, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 convertedPrice = (ethamt * getPrice(priceFeed)) / 1e18;
        return convertedPrice;
    }

    function getversion(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        return AggregatorV3Interface(priceFeed).version();
    }

    //library commands need to be exposed in the actual contract to be accesible to tests.
}
