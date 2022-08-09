// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;
pragma experimental ABIEncoderV2;

import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { StockFactory } from "src/StockFactory.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract StockFactoryTest is PRBTest, Cheats {
    StockFactory public factory;
    function setUp() public {
        factory = new StockFactory();
    }

    function testCreateCompanyStock() public {
        ICompanyStock.StockType memory stockType1;
        ICompanyStock.StockType memory stockType2;
        stockType1.name = "common";
        stockType1.totalSupply = 6969 ether;
        stockType2.name = "Type A";
        stockType2.totalSupply = 69 ether;

        ICompanyStock.StockType[] memory myStockTypeArray = new ICompanyStock.StockType[](2);
        myStockTypeArray[0] = stockType1;
        myStockTypeArray[1] = stockType2;

        address msft = factory.createCompanyStock("Microsoft", "MSFT", myStockTypeArray);
        console.logAddress(msft);
        address appl = factory.createCompanyStock("Apple", "APPL", myStockTypeArray);
        console.logAddress(appl);
        assertEq(msft, factory.allStocks(0));
        assertEq(appl, factory.allStocks(1));
        assertEq(factory.allStocksCount(), 2);
    }
}
