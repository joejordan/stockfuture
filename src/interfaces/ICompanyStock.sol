// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

interface ICompanyStock {
    struct StockType {
        uint256 id;
        string name;
        uint256 totalSupply;
    }

    function initialize(
        string memory _companyName,
        string memory _tickerSymbol
        // StockType[] memory _stockTypes
    ) external;
}
