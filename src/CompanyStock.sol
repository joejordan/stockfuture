// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC3525 } from "erc-3525/ERC3525.sol";
import { ERC3525Burnable } from "erc-3525/ERC3525Burnable.sol";
import { ERC3525SlotEnumerable } from "erc-3525/ERC3525SlotEnumerable.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is Initializable, ICompanyStock, Ownable2Step, ERC3525, ERC3525Burnable, ERC3525SlotEnumerable {
    
    mapping(uint256 => StockTypeData) public slots; // tracks our stock types

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

    function addStockTypes(StockTypeData[] calldata _stockTypes) public override onlyOwner returns (bool) {
        for (uint256 i = 0; i < _stockTypes.length; ++i) {
            addStockType(_stockTypes[i]);
        }
        return true;
    }

    function addStockType(StockTypeData calldata _stockTypeData) public onlyOwner returns (bool) {
        slots[slotCount()] = _stockTypeData;

        uint256 nextTokenId = totalSupply() + 1;

        mint(owner(), nextTokenId, slotCount(), _stockTypeData.totalSupply);

        return true;
    }

    function stockTotalSupply(uint256 _slotId) public view returns (uint256) {
        return slots[_slotId].totalSupply;
    }

    // function mintValue(tokenId_, value_) public override returns (bool) {
    //     // mintValue
    // }

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
