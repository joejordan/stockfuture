// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;
pragma experimental ABIEncoderV2;

// import { console } from "forge-std/console.sol";
import { IStockFactory } from "./interfaces/IStockFactory.sol";
import { ICompanyStock } from "./interfaces/ICompanyStock.sol";
import { CompanyStock } from "./CompanyStock.sol";

contract StockFactory is IStockFactory {
    address[] public allStocks;

    /**
     *  @dev create new company stock contract without any initial stockType data
     */
    function createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol,
        uint8 _decimals
    ) external returns (address) {
        // create and initialize CompanyStock contract
        return _createCompanyStock(_companyName, _tickerSymbol, _decimals);
    }

    function allStocksCount() external view returns (uint256 count) {
        count = allStocks.length;
    }

    function allStocksList() external view returns (address[] memory stocksList) {
        stocksList = allStocks;
    }

    function _createCompanyStock(
        string memory _companyName,
        string memory _tickerSymbol,
        uint8 _decimals
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

        // initialize CompanyStock
        CompanyStock(companyAddress).initialize(_companyName, _tickerSymbol, _decimals);

        // add new companyStock address to allstocks storage array
        allStocks.push(companyAddress);

        // alert the world of the new company stock that was created
        emit CompanyStockCreated(_companyName, _tickerSymbol, companyAddress, allStocks.length);
    }
}
