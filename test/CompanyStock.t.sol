// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "prb-test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { console } from "forge-std/console.sol";
import { StockFactory } from "../src/StockFactory.sol";
import { CompanyStock } from "../src/CompanyStock.sol";
import { IStockFactory } from "../src/interfaces/IStockFactory.sol";
import { ICompanyStock } from "../src/interfaces/ICompanyStock.sol";

contract CompanyStockTest is PRBTest, StdCheats {
    StockFactory public factory;

    function setUp() public {
        factory = new StockFactory();
    }

    function testCreateNewCompany() public {
        factory.createCompanyStock("NVIDIA", "NVDA", testCreateStockType("common", "CMN", 69 ether));
    }

    function testCreateStockType(string memory _name, string memory _symbol, uint256 _totalSupply)
        public
        pure
        returns (ICompanyStock.StockTypeData[] memory)
    {
        ICompanyStock.StockTypeData[] memory _stockType = new ICompanyStock.StockTypeData[](1);
        _stockType[0].name = _name;
        _stockType[0].symbol = _symbol;
        _stockType[0].totalSupply = _totalSupply;
        return _stockType;
    }

    function testInterfaceId() public view {
        console.logBytes4(type(IStockFactory).interfaceId);
    }
}
