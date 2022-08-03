// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { IStockFactory } from "src/interfaces/IStockFactory.sol";
import { CompanyStock } from "src/CompanyStock.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract StockFactory is IStockFactory {
    address[] public allStocks;

    function createCompanyStock(string memory companyName, string memory tickerSymbol)
        external
        returns (address companyAddress)
    {
        bytes memory bytecode = type(CompanyStock).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, companyName, tickerSymbol));
        assembly {
            companyAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ICompanyStock(companyAddress).initialize(companyName, tickerSymbol);
        allStocks.push(companyAddress);
        emit CompanyStockCreated(companyName, tickerSymbol, companyAddress, allStocks.length);
    }
}
