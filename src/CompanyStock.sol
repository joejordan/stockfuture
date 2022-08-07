// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { ERC1155 } from "solmate/tokens/ERC1155.sol";
import { IERC1155 } from "@openzeppelin/token/ERC1155/IERC1155.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is ICompanyStock {
    // company info
    string public companyName;
    string public tickerSymbol;
    uint numStockTypes;
    mapping (uint => StockType) stockTypes;

    address public factory;

    constructor() {
        factory = msg.sender;
    }

    function initialize(string memory _companyName, string memory _tickerSymbol, StockType[] memory _stockTypes)
        public
    // StockType[] memory _stockTypes
    {
        require(msg.sender == factory, "StockFuture: FORBIDDEN");
        companyName = _companyName;
        tickerSymbol = _tickerSymbol;
        for (uint256 i = 0; i < _stockTypes.length; i++) {
            stockTypes[i] = _stockTypes[i];
        }
    }
}
