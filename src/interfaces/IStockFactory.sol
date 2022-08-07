// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

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
        ICompanyStock.StockType[] memory _stockTypes
    ) external returns (address companyAddress);

    function allStocksCount() external returns (uint256 count);

    function allStocksList() external view returns (address[] memory stocksList);
}
