// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

interface ICompanyStock {

    struct ScaleValue {
        uint256 numerator;
        uint256 denominator;
    }

    struct StockTypeData {
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;    // assigned by owner, incrementable/decrementable via mint/burn
        ScaleValue scale;       // create scale to split/multiply stock values, etc.
    }

    function addStockTypes(StockTypeData[] calldata _stockTypes) external returns (bool);
    function addStockType(StockTypeData calldata _stockType) external returns (bool);
}
