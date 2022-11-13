// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

interface ICompanyStock {
    struct StockType {
        string name;
        uint8 slotNumber;
        uint256 totalSupply;
    }

    function addStockTypes(StockType[] calldata _stockTypes) external returns (bool);
    function addStockType(StockType calldata _stockType) external returns (bool);
}
