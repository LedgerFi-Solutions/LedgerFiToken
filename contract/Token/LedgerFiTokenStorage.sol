// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

abstract contract LedgerFiTokenStorage {
    uint256 public immutable maxSupply;
    uint256 public immutable preMinedToken;
    uint256 public burnThreshold;

    address public immutable vestingTeamAddress;
    address public immutable vestingAdvisorsAddress;
    address public immutable vestingSeedSaleAddress;
    address public immutable vestingCommunityAddress;
    address public immutable vestingMarketingAddress;
    address public immutable vestingEcosystemAddress;
    address public immutable vestingPMLAddress;

    uint8 public immutable vestingTeamPercent;
    uint8 public immutable vestingAdvisorsPercent;
    uint8 public immutable vestingSeedSalePercent;
    uint8 public immutable vestingPublicSalePercent;
    uint8 public immutable vestingCommunityPercent;
    uint8 public immutable vestingMarketingPercent;
    uint8 public immutable vestingEcosystemPercent;
    uint8 public immutable vestingExchangePercent;
    uint8 public immutable vestingPMLPercent;

    address public immutable burnTokenAddress;

    constructor() {
        maxSupply = 500000000 ether; //max supply  500 millions
        preMinedToken = 400000000 ether; //premined token count 400 millions

        burnThreshold = 100000 ether; // when the burnTokensCount reaches burnThreshold, do burning

        // Contract address in which all 9 take holders token stored on premining
        //some sample address assigned, it will be different for all..

        vestingTeamAddress = 0x22cf0b5E37ac801266BB3C4349b236e1d25b7f3E;
        vestingAdvisorsAddress = 0xC9ae2A41D9911a65DbD6c4BE451a727074b583BF;
        vestingSeedSaleAddress = 0xE88524f322b76069CA71F129e57E3Fcd7041BC5C;
        vestingCommunityAddress = 0x1dc079802dcaC03a986218b151f6F34f178dC628;
        vestingMarketingAddress = 0xb74b38ab404a23eA20Fa0f6e76C9cea240f3413B;
        vestingEcosystemAddress = 0xE704584C3f41596E15b4dF312557e31F432402c1;
        vestingPMLAddress = 0x97ee747d6E0bbBe8B0F765ADE860244787Ee9DED;

        burnTokenAddress = 0xc2ab51a8FBaf7f421A116dF8C395c44f12dF2958;

        // % of token premined for each stake holders

        vestingTeamPercent = 15;
        vestingAdvisorsPercent = 3;
        vestingSeedSalePercent = 5;
        vestingPublicSalePercent = 20;
        vestingCommunityPercent = 20;
        vestingMarketingPercent = 10;
        vestingEcosystemPercent = 7;
        vestingExchangePercent = 10;
        vestingPMLPercent = 10;
    }
}
