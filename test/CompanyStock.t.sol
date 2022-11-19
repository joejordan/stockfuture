// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { PRBTest } from "prb-test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { console } from "forge-std/console.sol";
import { StockFactory } from "src/StockFactory.sol";
import { CompanyStock } from "src/CompanyStock.sol";
import { IStockFactory } from "src/interfaces/IStockFactory.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStockTest is PRBTest, StdCheats {
    StockFactory public factory;
    CompanyStock public companyStock;

    address public meAddress = address(0x69);

    uint8 public constant DEFAULT_DECIMALS = 18;

    function setUp() public {
        factory = new StockFactory();

        vm.startPrank(meAddress, meAddress);
        companyStock = CompanyStock(factory.createCompanyStock("Tesla", "TSLA", 18));

        console.log("Factory address:", address(factory));
        console.log("companyStock Owner:", CompanyStock(companyStock).owner());
        console.log("msg.sender", msg.sender);
        console.log("tx.origin", tx.origin);

        vm.stopPrank();
    }

    function testCreateNewCompany() public {
        factory.createCompanyStock("NVIDIA", "NVDA", 18);
    }

    function testMintValue() public {
        vm.startPrank(meAddress);
        ICompanyStock.StockTypeData[] memory stockTypeData = createStockType(
            "Common",
            "TSLA",
            DEFAULT_DECIMALS,
            5000 ether
        );

        companyStock.addStockTypes(stockTypeData);

        uint256 slotToCheck = companyStock.slotOf(companyStock.totalSupply());
        uint256 slotTotalSupply = companyStock.slotTotalSupply(slotToCheck);
        console.log("Total Supply for Slot:", slotTotalSupply);
        assertEq(slotTotalSupply, 5000 ether);

        companyStock.mintValue(companyStock.totalSupply(), 69 ether);
        console.log("Total Supply for Slot:", companyStock.slotTotalSupply(slotToCheck));
        assertEq(companyStock.slotTotalSupply(slotToCheck), 5069 ether);
        vm.stopPrank();
    }

    function testInterfaceId() public view {
        console.logBytes4(type(IStockFactory).interfaceId);
    }

    /**
     * Utility functions
     */

    function createStockType(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) public pure returns (ICompanyStock.StockTypeData[] memory) {
        ICompanyStock.StockTypeData[] memory _stockType = new ICompanyStock.StockTypeData[](1);
        _stockType[0].name = _name;
        _stockType[0].symbol = _symbol;
        _stockType[0].totalSupply = _totalSupply;
        return _stockType;
    }
}
