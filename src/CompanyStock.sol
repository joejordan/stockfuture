// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { console } from "forge-std/console.sol";
import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC3525 } from "erc-3525-extended/ERC3525.sol";
import { IERC3525 } from "erc-3525-extended/IERC3525.sol";
import { ERC3525Burnable } from "erc-3525-extended/ERC3525Burnable.sol";
import { ERC3525SlotEnumerable } from "erc-3525-extended/ERC3525SlotEnumerable.sol";
import { ERC3525SlotMetadata } from "erc-3525-extended/ERC3525SlotMetadata.sol";
import { ICompanyStock } from "src/interfaces/ICompanyStock.sol";

contract CompanyStock is
    Initializable,
    ICompanyStock,
    Ownable2Step,
    ERC3525,
    ERC3525Burnable,
    ERC3525SlotEnumerable,
    ERC3525SlotMetadata
{

    function initialize(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public virtual override(ERC3525SlotEnumerable, ERC3525Burnable) initializer {
        // initialize ERC3525Burnable
        __ERC3525Burnable_init(name_, symbol_, decimals_);

        // override the default owner (StockFactory) upon contract initialization
        _transferOwnership(tx.origin);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC3525, ERC3525SlotEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function addStockTypes(SlotMetadata[] calldata _stockTypes) public override onlyOwner returns (bool) {
        for (uint256 i = 0; i < _stockTypes.length; ++i) {
            addStockType(_stockTypes[i], 0);
        }
        return true;
    }

    function addStockType(SlotMetadata memory _stockTypeData, uint256 _initialSupply) public onlyOwner returns (bool) {
        // get next ids to mint
        uint256 _nextTokenId = nextTokenId();
        uint256 _nextSlotId = slotCount();

        // slot must exist before we can mint tokens to it
        _createSlot(_nextSlotId);
        initializeSlotMetadata(_nextSlotId, _stockTypeData.name, _stockTypeData.symbol, _stockTypeData.decimals);

        // mint token with new slot type
        mint(owner(), _nextTokenId, _nextSlotId, _initialSupply);

        return true;
    }

    function balanceOf(uint256 tokenId_) public view override(ERC3525, IERC3525) returns (uint256) {
        // get unscaled balance
        uint256 unscaledBalance = super.balanceOf(tokenId_);

        // ////////////////////////////////////////////////////////
        // // determine if we need to scale the user's balance
        // ////////////////////////////////////////////////////////

        // // extract slot of passed token
        // uint256 slotOfToken = slotOf(tokenId_);
        // // get scale of slot
        // ScaleValue memory scale = slots[slotOfToken].scale;

        // if (isScaleSet(scale)) {
        //     // scale balance and return
        //     return (unscaledBalance * scale.numerator) / scale.denominator;
        // }
        // return unscaled balance
        return unscaledBalance;
    }

    // function slotTotalSupply(uint256 slot_) public view returns (uint256) {
    //     uint256 unscaledTotalSupply = slots[slot_].totalSupply;

    //     ScaleValue memory scale = slots[slot_].scale;

    //     if (isScaleSet(scale)) {
    //         console.log(
    //             "slotTotalSupply scaled total:",
    //             (unscaledTotalSupply * scale.numerator) / scale.denominator);
    //         // scale balance and return
    //         return (unscaledTotalSupply * scale.numerator) / scale.denominator;
    //     }
    //     // return unscaled totalSupply
    //     return unscaledTotalSupply;
    // }

    // /// @dev reset scale by passing (0,0) to ScaleValue
    // function slotScaleValue(uint256 slot_, ScaleValue memory scale_) public onlyOwner {
    //     // require(_slotExists(slot_), "Slot does not exist");
    //     slots[slot_].scale = scale_;
    // }

    function nextTokenId() public returns (uint256) {
        return _createOriginalTokenId();
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

    function isScaleSet(ScaleValue memory scale_) private pure returns (bool) {
        return !(scale_.numerator == 0 && scale_.denominator == 0);
    }
}
