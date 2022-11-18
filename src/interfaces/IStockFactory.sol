// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

import "src/interfaces/ICompanyStock.sol";

interface IStockFactory {
    event CompanyStockCreated(
        string indexed companyName,
        string indexed tickerSymbol,
        address indexed stockAddress,
        uint256 companyCount
    );

    function createCompanyStock(
        string memory companyName,
        string memory tickerSymbol,
        uint8 decimals
    ) external returns (address companyAddress);

    function allStocksCount() external returns (uint256 count);

    function allStocksList() external view returns (address[] memory stocksList);
}
