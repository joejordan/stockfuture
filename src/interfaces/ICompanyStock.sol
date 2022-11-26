// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import { IERC3525SlotMetadata } from "erc-3525-extended/IERC3525SlotMetadata.sol";

interface ICompanyStock is IERC3525SlotMetadata {

    struct ScaleValue {
        uint256 numerator;
        uint256 denominator;
    }

    function addStockTypes(SlotMetadata[] calldata _stockTypes) external returns (bool);
    function addStockType(SlotMetadata calldata _stockType, uint256 _initialSupply) external returns (bool);
}
