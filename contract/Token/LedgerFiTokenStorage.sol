// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;

abstract contract LedgerFiTokenStorage {
    uint256 public immutable maxSupply;
    uint256 public immutable preMinedToken;
    uint256 public burnThreshold;

    address public immutable vestingTeamAddress;
    address public immutable vestingAdvisorsAddress;
    address public immutable vestingSeedSaleAddress;
    address public immutable vestingPublicSaleAddress;
    address public immutable vestingCommunityAddress;
    address public immutable vestingMarketingAddress;
    address public immutable vestingEcosystemAddress;
    address public immutable vestingExchangeAddress;
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
        maxSupply = 500000000 ether; //max supply
        preMinedToken = 400000000 ether; //premined token count

        burnThreshold = 100000 ether; // when the burnTokensCount reaches burnThreshold, do burning

        // Contract address in which all 9 take holders token stored on premining
        //some sample address assigned, it will be different for all..

        vestingTeamAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingAdvisorsAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingSeedSaleAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingPublicSaleAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingCommunityAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingMarketingAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingEcosystemAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingExchangeAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;
        vestingPMLAddress = 0x88DE49ECf0c5da1dCADd8c24D2F4c4a71ee0c19B;

        burnTokenAddress = 0x1FE48906040b2a180c14919FEa2cA0BD2B5fe97d;

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
