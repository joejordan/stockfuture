// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ERC3525 } from "erc-3525/ERC3525.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is ICompanyStock, ERC3525 {
    // company info
    string public companyName;
    string public tickerSymbol;
    uint256 public stockTypeCount;

    mapping(uint256 => StockType) public stockTypes;

    address public factory;

    constructor(string memory uri_) ERC1155(uri_) {
        factory = msg.sender;
    }

    function initialize(
        string calldata _companyName,
        string calldata _tickerSymbol,
        StockType[] calldata _stockTypes
    ) public returns (bool) {
        require(msg.sender == factory, "StockFuture: FORBIDDEN");
        companyName = _companyName;
        tickerSymbol = _tickerSymbol;
        for (uint256 i = 0; i < _stockTypes.length; i++) {
            stockTypes[i] = _stockTypes[i];
        }
        stockTypeCount = _stockTypes.length;
        return true;
    }

    function addStockType(StockType calldata _stockType) public returns (bool) {
        stockTypes[stockTypeCount + 1] = _stockType;
        return true;
    }
}
