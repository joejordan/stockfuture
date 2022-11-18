// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;
pragma experimental ABIEncoderV2;

import { StdCheats } from "forge-std/StdCheats.sol";
import { console } from "forge-std/console.sol";
import { PRBTest } from "@prb/test/PRBTest.sol";

import { StockFactory } from "../src/StockFactory.sol";
import { CompanyStock } from "../src/CompanyStock.sol";
import { ICompanyStock } from "../src/interfaces/ICompanyStock.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract StockFactoryTest is PRBTest, StdCheats {
    StockFactory public factory;
    CompanyStock public companyStock;
    address public meAddress = address(0x69);

    uint8 constant public DEFAULT_DECIMALS = 18;

    function setUp() public {
        vm.startPrank(meAddress, meAddress);
        factory = new StockFactory();
        companyStock = CompanyStock(factory.createCompanyStock("TESTERz", "TST", DEFAULT_DECIMALS));

        console.log("companyStock Owner:", companyStock.owner());
        console.log("Me:", msg.sender);
        vm.stopPrank();
    }

    function testCreateCompanyStock() public {
        ICompanyStock.StockTypeData memory stockType1;
        ICompanyStock.StockTypeData memory stockType2;
        stockType1.name = "common";
        stockType1.totalSupply = 6969 ether;
        stockType1.decimals = DEFAULT_DECIMALS;
        stockType2.name = "Type A";
        stockType2.totalSupply = 69 ether;
        stockType2.decimals = DEFAULT_DECIMALS;

        ICompanyStock.StockTypeData[] memory myStockTypeArray = new ICompanyStock.StockTypeData[](2);
        myStockTypeArray[0] = stockType1;
        myStockTypeArray[1] = stockType2;

        vm.startPrank(meAddress, meAddress);

        address msft = factory.createCompanyStock("Microsoft", "MSFT", DEFAULT_DECIMALS);
        console.logAddress(msft);
        address appl = factory.createCompanyStock("Apple", "APPL", DEFAULT_DECIMALS);
        console.logAddress(appl);
        assertEq(msft, factory.allStocks(0));
        assertEq(appl, factory.allStocks(1));
        assertEq(factory.allStocksCount(), 2);

        vm.stopPrank();
    }

    function testCheckOwnership() public {
        console.log("Owner:", companyStock.owner());
    }

    function testCheckFactory() public {
        console.log("Factory:", address(factory));
    }

    function createCompany() private returns(address) {
        return factory.createCompanyStock("Ignite Software", "IGS", DEFAULT_DECIMALS);
    }
}
