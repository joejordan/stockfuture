// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC3525Burnable } from "erc-3525/ERC3525Burnable.sol";
import { ERC3525SlotEnumerable } from "erc-3525/ERC3525SlotEnumerable.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is ICompanyStock, Initializable, Ownable2Step, ERC3525SlotEnumerable {
    // company info
    uint256 public stockTypeCount;

    mapping(uint256 => StockType) public stockTypes;

    address public factory;

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) ERC3525SlotEnumerable(name_, symbol_, decimals_) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function initialize(
        StockType[] calldata _stockTypes
    ) public initializer returns (bool) {
        require(msg.sender == factory, "StockFuture: `initialize` can only be called from the Factory");
        for (uint256 i = 0; i < _stockTypes.length; i++) {
            stockTypes[i] = _stockTypes[i];
        }
        stockTypeCount = _stockTypes.length;
        return true;
    }

    function addStockType(StockType calldata _stockType) public onlyOwner returns (bool) {
        stockTypes[stockTypeCount + 1] = _stockType;
        // mint(mintTo_, tokenId_, slot_, value_);
        return true;
    }
}
