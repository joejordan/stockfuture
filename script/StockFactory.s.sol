// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { StockFactory } from "src/StockFactory.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract StockFactoryScript is Script {
    StockFactory internal stockFactory;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        // uint256 privKey = vm.deriveKey(vm.envString("MNEMONIC"), index);
        // address deployer = vm.rememberKey(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);
        stockFactory = new StockFactory();
        vm.stopBroadcast();
    }
}
