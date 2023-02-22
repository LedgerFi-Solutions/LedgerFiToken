// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./ERC20Burnable.sol";
import "./RoleControl.sol";
import "./LedgerFiTokenStorage.sol";

//upgradable contract

contract LedgerFiToken is ERC20Burnable, RoleControl, LedgerFiTokenStorage {
    mapping(address => bool) _blacklist;

    event BlacklistUpdated(address indexed user, bool value);

    constructor()
        ERC20("LedgerFi Token", "LFT", 18)
        RoleControl()
        LedgerFiTokenStorage()
    {
        //check the LedgerFiStorage.sol for more info

        mintVesting(); // above % of token mined to each address
    }

    function mint(address to, uint256 amount) public onlyMinterBurner {
        require(
            totalSupply() + amount <= maxSupply,
            "Can't mint these many tokens, because it will cross the maximum supply"
        );
        //require(_owner == _msgSender(), "Only owner is allowed to mint token.");
        _mint(to, amount);
    }

    //after each allocation balance token will be minted to a burnTokenAddress(contract) and
    ////if token to be burned is greater than threshold of burning .. it calls burning token function
    function addBurnTokenCount(uint256 amount) public onlyMinterBurner {
        _mint(burnTokenAddress, amount);

        if (balanceOf(burnTokenAddress) >= burnThreshold) {
            burnDirect(burnTokenAddress, balanceOf(burnTokenAddress));
        }
    }

    function getBurnTokenCount()
        public
        view
        onlyMinterBurner
        returns (uint256)
    {
        return balanceOf(burnTokenAddress);
    }

    function mintVesting() private onlyOwner {
        _mint(vestingTeamAddress, (preMinedToken * vestingTeamPercent) / 100);
        _mint(
            vestingAdvisorsAddress,
            (preMinedToken * vestingAdvisorsPercent) / 100
        );
        _mint(
            vestingSeedSaleAddress,
            (preMinedToken * vestingSeedSalePercent) / 100
        );

        _mint(
            vestingCommunityAddress,
            (preMinedToken * vestingCommunityPercent) / 100
        );
        _mint(
            vestingMarketingAddress,
            (preMinedToken * vestingMarketingPercent) / 100
        );
        _mint(
            vestingEcosystemAddress,
            (preMinedToken * vestingEcosystemPercent) / 100
        );

        _mint(vestingPMLAddress, (preMinedToken * vestingPMLPercent) / 100);
    }

    function blacklistUpdate(address user, bool value)
        public
        virtual
        onlyOwner
    {
        // require(_owner == _msgSender(), "Only owner is allowed to modify blacklist.");
        _blacklist[user] = value;
        emit BlacklistUpdated(user, value);
    }

    function isBlackListed(address user) public view returns (bool) {
        return _blacklist[user];
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(ERC20) {
        require(
            !isBlackListed(to),
            "Token transfer refused. Receiver is on blacklist"
        );
        require(
            !isBlackListed(from),
            "Token transfer refused. You are on blacklist"
        );
        super._beforeTokenTransfer(from, to, amount);
    }
}
