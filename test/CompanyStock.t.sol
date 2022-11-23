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

    address public bossman = address(0x69);
    address public alice = address(0x11123);
    address public bob = address(0x22246);

    uint8 public constant DEFAULT_DECIMALS = 18;

    ICompanyStock.ScaleValue public scale;

    function setUp() public {
        factory = new StockFactory();

        vm.startPrank(bossman, bossman);
        companyStock = CompanyStock(factory.createCompanyStock("Tesla", "TSLA", 18));

        // console.log("Factory address:", address(factory));
        // console.log("companyStock Owner:", CompanyStock(companyStock).owner());
        // console.log("msg.sender", msg.sender);
        // console.log("tx.origin", tx.origin);

        vm.stopPrank();
    }

    function testCreateNewCompany() public {
        factory.createCompanyStock("NVIDIA", "NVDA", 18);
    }

    function testNewStockType() public {
        ICompanyStock.StockTypeData[] memory stockTypeData = teslaStockType();

        vm.startPrank(bossman);
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

    function testMint() public {
        vm.startPrank(bossman);
        basicSlotSetup();
        uint256 slotToCheck = companyStock.slotOf(companyStock.totalSupply());
        console.log("Total Supply for Slot INITIAL:", companyStock.slotTotalSupply(slotToCheck));

        uint256 bossToken = companyStock.nextTokenId();
        companyStock.mint(bossman, bossToken, slotToCheck, 6900);
        uint256 aliceToken = companyStock.nextTokenId();
        companyStock.mint(alice, aliceToken, slotToCheck, 0.6 ether);
        uint256 bobToken = companyStock.nextTokenId();
        companyStock.mint(bob, bobToken, slotToCheck, 0.9 ether);

        console.log("Total Supply for Slot AFTERMINT:", companyStock.slotTotalSupply(slotToCheck));
        vm.stopPrank();
    }

    function testScale() public {
        vm.startPrank(bossman);
        basicSlotSetup();
        // basicAccountSetup();


        uint256 bossToken = companyStock.nextTokenId();
        companyStock.mint(bossman, bossToken, 0, 6900);
        uint256 aliceToken = companyStock.nextTokenId();
        companyStock.mint(alice, aliceToken, 0, 1111111111111111111111111111 ether);
        uint256 bobToken = companyStock.nextTokenId();
        companyStock.mint(bob, bobToken, 0, 0.9 ether);

        console.log("Total Supply for Slot AFTERMINT:", companyStock.slotTotalSupply(0));
        console.log("ALICE BALANCE:", companyStock.balanceOf(aliceToken));

        scale = ICompanyStock.ScaleValue({
            numerator: 400_000,
            denominator: 65_214
        });
        companyStock.slotScaleValue(companyStock.slotOf(bossToken), scale);

        console.log("Total Supply for Slot AFTERSCALE:", companyStock.slotTotalSupply(0));
        console.log("ALICE BALANCE:", companyStock.balanceOf(aliceToken));
        vm.stopPrank();
    }

    function testInterfaceId() public view {
        console.logBytes4(type(IStockFactory).interfaceId);
    }

    /**
     * Utility functions
     */

    function basicSlotSetup() public {
        ICompanyStock.StockTypeData[] memory stockTypeData = teslaStockType();
        companyStock.addStockTypes(stockTypeData);
    }

    function basicAccountSetup() public {
        uint256 bossToken = companyStock.nextTokenId();
        companyStock.mint(bossman, bossToken, 0, 6900);
        uint256 aliceToken = companyStock.nextTokenId();
        companyStock.mint(alice, aliceToken, 0, 0.6 ether);
        uint256 bobToken = companyStock.nextTokenId();
        companyStock.mint(bob, bobToken, 0, 0.9 ether);
    }

    function teslaStockType() public pure returns (ICompanyStock.StockTypeData[] memory) {
        ICompanyStock.StockTypeData[] memory stockTypeData = createStockType(
            "Common",
            "TSLA",
            DEFAULT_DECIMALS,
            69000 ether
        );

        return stockTypeData;
    }

    function createStockType(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) public pure returns (ICompanyStock.StockTypeData[] memory) {
        ICompanyStock.StockTypeData[] memory _stockType = new ICompanyStock.StockTypeData[](1);
        _stockType[0].name = _name;
        _stockType[0].symbol = _symbol;
        _stockType[0].decimals = _decimals;
        _stockType[0].totalSupply = _totalSupply;
        return _stockType;
    }
}
