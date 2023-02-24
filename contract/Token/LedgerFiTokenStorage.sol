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

        vestingTeamAddress = 0x9b874C147a4a95Bb843568BEeD8cF38106118Fca; //

        vestingAdvisorsAddress = 0x278d005b9BFf3e5fe6E03A9C8A78f8AacF7C4639; //

        vestingSeedSaleAddress = 0xd4b149aBbA8058cf003919659b78A4C982Ad8e30; //

        vestingCommunityAddress = 0xb159A6460C764fEa791174a3ddA2889966Db3a88; //

        vestingMarketingAddress = 0x524D1487564c27ab29F07D59f04B4FB251574983; //

        vestingEcosystemAddress = 0x9D77CbA8B23C6d7B9B40A6409aC514E3253213ce; //

        vestingPMLAddress = 0x6BD21Cf8eab4A913A5D7dc4130045e830C41F736; //

        burnTokenAddress = 0xF011a8dB1DA611256d78fFB600EfF2ef938FB687;

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
