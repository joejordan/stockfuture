// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC3525 } from "erc-3525/ERC3525.sol";
import { ERC3525Burnable } from "erc-3525/ERC3525Burnable.sol";
import { ERC3525SlotEnumerable } from "erc-3525/ERC3525SlotEnumerable.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is Initializable, ICompanyStock, Ownable2Step, ERC3525, ERC3525Burnable, ERC3525SlotEnumerable {
    // company info
    uint256 public stockTypeCount;

    mapping(uint256 => StockType) public stockTypes;

    address public factory;

    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public virtual override(ERC3525Burnable, ERC3525SlotEnumerable) initializer {
        __ERC3525Burnable_init(name_, symbol_, decimals_);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC3525, ERC3525SlotEnumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function addStockTypes(StockType[] calldata _stockTypes) public override onlyOwner returns (bool) {
        for (uint256 i = 0; i < _stockTypes.length; i++) {
            stockTypes[i] = _stockTypes[i];
        }
        stockTypeCount = _stockTypes.length;
        return true;
    }

    function addStockType(StockType calldata _stockType) public onlyOwner returns (bool) {
        stockTypeCount += 1;
        stockTypes[stockTypeCount] = _stockType;

        // mint(mintTo_, tokenId_, slot_, value_);
        // mint(_msgSender(), tokenId_, slot_, value_);
        return true;
    }

    function _beforeValueTransfer(
        address from_,
        address to_,
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 slot_,
        uint256 value_
    ) internal override(ERC3525, ERC3525SlotEnumerable) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function _afterValueTransfer(
        address from_,
        address to_,
        uint256 fromTokenId_,
        uint256 toTokenId_,
        uint256 slot_,
        uint256 value_
    ) internal override(ERC3525, ERC3525SlotEnumerable) {
        // solhint-disable-previous-line no-empty-blocks
    }
}
