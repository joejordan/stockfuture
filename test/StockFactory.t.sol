// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Cheats } from "forge-std/Cheats.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { StockFactory } from "src/StockFactory.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract StockFactoryTest is PRBTest, Cheats {
    StockFactory public factory;
    function setUp() public {
        factory = new StockFactory();
    }

    function testCreateCompanyStock() public {
        address msft = factory.createCompanyStock("Microsoft", "MSFT");
        console.logAddress(msft);
        address appl = factory.createCompanyStock("Apple", "APPL");
        console.logAddress(appl);
        assertEq(msft, factory.allStocks(0));
        assertEq(appl, factory.allStocks(1));
        assertEq(factory.allStocksCount(), 2);
    }
}
