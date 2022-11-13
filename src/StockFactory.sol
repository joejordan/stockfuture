// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

import { IStockFactory } from "src/interfaces/IStockFactory.sol";
import { CompanyStock } from "src/CompanyStock.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract StockFactory is IStockFactory {
    address[] public allStocks;

    function createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol
    ) external returns (address companyAddress) {

        // get bytecode of CompanyStock contract and append CompanyStock constructor arguments
        bytes memory bytecode = abi.encodePacked(type(CompanyStock).creationCode, abi.encode(""));

        /**
         *  calculate a salt based upon msg.sender, company name and ticker symbol.
         *  This will prevent an address from creating more than one of an identical company.
         */
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, _companyName, _tickerSymbol));

        // assembly block to access the create2 opcode
        assembly {
            companyAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        // confirm that that the bytecode has been deployed
        require(companyAddress != address(0), "DEPLOYMENT_FAILED");

        emit CompanyStockCreated(_companyName, _tickerSymbol, companyAddress, allStocks.length);
    }
    function createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol,
        ICompanyStock.StockType[] calldata _stockTypes
    ) external returns (address companyAddress) {

        // create CompanyStock contract
        companyAddress = _createCompanyStock(_companyName, _tickerSymbol);

        // add initial stock types
        CompanyStock(companyAddress).addStockTypes(_stockTypes);

        // push new CompanyStock address to our allStocks array
        allStocks.push(companyAddress);
        emit CompanyStockCreated(_companyName, _tickerSymbol, companyAddress, allStocks.length);
    }

    function allStocksCount() external view returns (uint256 count) {
        count = allStocks.length;
    }

    function allStocksList() external view returns (address[] memory stocksList) {
        stocksList = allStocks;
    }

    function _createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol
    ) private returns (address companyAddress) {

        // get bytecode of CompanyStock contract and append CompanyStock constructor arguments
        bytes memory bytecode = abi.encodePacked(type(CompanyStock).creationCode, abi.encode(""));

        /**
         *  calculate a salt based upon msg.sender, company name and ticker symbol.
         *  This will prevent an address from creating more than one of an identical company.
         */
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, _companyName, _tickerSymbol));

        // assembly block to access the create2 opcode
        assembly {
            companyAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        // confirm that that the bytecode has been deployed
        require(companyAddress != address(0), "DEPLOYMENT_FAILED");

        emit CompanyStockCreated(_companyName, _tickerSymbol, companyAddress, allStocks.length);
    }
}
