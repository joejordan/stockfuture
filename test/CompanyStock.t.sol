// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "prb-test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { console } from "forge-std/console.sol";
import { StockFactory } from "src/StockFactory.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStockTest is PRBTest, StdCheats {
    StockFactory public factory;

    function setUp() public {
        factory = new StockFactory();
    }

    function testCreateNewCompany() public {
        factory.createCompanyStock("NVIDIA", "NVDA", testCreateStockType("common", 69 ether));
    }

    function testCreateStockType(string memory _name, uint256 _totalSupply)
        public
        pure
        returns (ICompanyStock.StockType[] memory)
    {
        ICompanyStock.StockType[] memory _stockType = new ICompanyStock.StockType[](1);
        _stockType[0].name = _name;
        _stockType[0].totalSupply = _totalSupply;
        return _stockType;
    }

    function testInterfaceId() public {
        console.logBytes4(type(StockFactory).interfaceId);
    }
}
