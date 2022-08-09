// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

interface ICompanyStock {
    struct StockType {
        string name;
        uint256 totalSupply;
    }

    function initialize(
        string calldata _companyName,
        string calldata _tickerSymbol,
        StockType[] calldata _stockTypes
    ) external;
}
