// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { console } from "forge-std/console.sol";
import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC3525 } from "erc-3525/ERC3525.sol";
import { IERC3525 } from "erc-3525/IERC3525.sol";
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
        // initialize ERC3525Burnable
        __ERC3525Burnable_init(name_, symbol_, decimals_);

        // override the default owner (StockFactory) upon contract initialization
        _transferOwnership(tx.origin);
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
        uint256 nextSlotId = slotCount();

        _createSlot(nextSlotId);

        mint(owner(), nextTokenId, nextSlotId, _stockTypeData.totalSupply);

        return true;
    }

    function balanceOf(uint256 tokenId_) public view override(ERC3525, IERC3525) returns (uint256) {
        // get unscaled balance
        uint unscaledBalance = super.balanceOf(tokenId_);

        ////////////////////////////////////////////////////////
        // determine if we need to scale the user's balance
        ////////////////////////////////////////////////////////

        // extract slot of passed token
        uint256 slotOfToken = slotOf(tokenId_);
        // get scale of slot
        ScaleValue memory scale = slots[slotOfToken].scale;

        if (isScaleSet(scale)) {
            // scale balance and return
            return (unscaledBalance * scale.numerator) / scale.denominator;
        }
        // return unscaled balance
        return unscaledBalance;
    }

    function slotTotalSupply(uint256 slot_) public view returns (uint256) {
        uint256 unscaledTotalSupply = slots[slot_].totalSupply;

        ScaleValue memory scale = slots[slot_].scale;

        if (isScaleSet(scale)) {
            // scale balance and return
            return (unscaledTotalSupply * scale.numerator) / scale.denominator;
        }
        // return unscaled totalSupply
        return unscaledTotalSupply;
    }

    function mint(address mintTo_, uint256 tokenId_, uint256 slot_, uint256 value_) public override onlyOwner {
        super.mint(mintTo_, tokenId_, slot_, value_);
        slots[slotOf(tokenId_)].totalSupply += value_;
    }

    function mintValue(uint256 tokenId_, uint256 value_) public override onlyOwner {
        require(value_ > 0, "Mint value must be greater than 0");
        // mint value to token id; reverts if tokenId has not yet been minted
        super.mintValue(tokenId_, value_);
        // increment totalSupply of slot
        slots[slotOf(tokenId_)].totalSupply += value_;
    }

    function burn(uint256 tokenId_) public override {
        uint256 burnedValue = balanceOf(tokenId_);
        super.burn(tokenId_);
        slots[slotOf(tokenId_)].totalSupply -= burnedValue;
    }

    function burnValue(uint256 tokenId_, uint256 burnValue_) public override {
        super.burnValue(tokenId_, burnValue_);
        slots[slotOf(tokenId_)].totalSupply -= burnValue_;
    }

    function slotScaleValue(uint256 slot_, ScaleValue memory scale_) public onlyOwner {
        require(_slotExists(slot_), "Slot does not exist");
        slots[slot_].scale = scale_;
    }

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

    function isScaleSet(ScaleValue memory scale_) private view returns (bool) {
        console.log("SCALEVALUE 1", scale_.numerator);
        console.log("SCALEVALUE 2", scale_.denominator);
        console.log((scale_.numerator != 0 || scale_.denominator != 0));
        console.log(!(scale_.numerator == 0 && scale_.denominator == 0));
        return !(scale_.numerator == 0 && scale_.denominator == 0);
    }
}
