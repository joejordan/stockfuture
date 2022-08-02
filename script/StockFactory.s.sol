// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { StockFactory } from "../src/StockFactory.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract StockFactoryScript is Script {
    StockFactory internal stockFactory;

    function run() public {
        vm.startBroadcast();
        stockFactory = new StockFactory();
        vm.stopBroadcast();
    }
}
