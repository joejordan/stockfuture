// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { IStockFactory } from "src/interfaces/IStockFactory.sol";
import { CompanyStock } from "src/CompanyStock.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract StockFactory is IStockFactory {
    address[] public allStocks;

    function createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol,
        ICompanyStock.StockType[] calldata _stockTypes
    ) external returns (address companyAddress) {
        bytes memory bytecode = type(CompanyStock).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, _companyName, _tickerSymbol));
        assembly {
            companyAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ICompanyStock(companyAddress).initialize(_companyName, _tickerSymbol, _stockTypes);
        allStocks.push(companyAddress);
        emit CompanyStockCreated(_companyName, _tickerSymbol, companyAddress, allStocks.length);
    }

    function allStocksCount() external view returns (uint256 count) {
        count = allStocks.length;
    }

    function allStocksList() external view returns (address[] memory stocksList) {
        stocksList = allStocks;
    }
}
