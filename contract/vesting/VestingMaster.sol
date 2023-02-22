// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./RoleControl.sol";

import "./SafeERC20.sol";

// this contract imported to contract of each stakeholders(here TEAM) which requires vesting..
// all attributes are declared in Storage contract
//VestingTeam, VestingTeamProxy, vestingStorage are used to make upgradable contract
contract VestingMaster is RoleControl {
    using SafeERC20 for IERC20;

    constructor() {}

    event TokenAssigned(address indexed teamMemberAddress, uint256 amount);
    event TokenReleased(address indexed teamMemberAddress, uint256 amount);

    /*
    @dev Sets the value for ERC20 LFT token
    Only owner can do that  
    */

    function IERC20address(IERC20 token) external onlyOwner returns (IERC20) {
        require(
            token != IERC20(address(0)),
            "Zero address: Can't assign the given address as ERC20 token contract address"
        );
        _token = token;
        return token;
    }

    /*
    @dev Save {amount} of  ERC20 LFT token against the given {teamMemberAddress}
         The function do not transfer tokens to the  address {teamMemberAddress}, instead 
         it keep the allotted info in the {totalTokensAssigned}
    
         Only owner can do that


        The token is allotted from the premined tokens in this contract addess
        {Total token} -  Total mined tokens in the contract address
        {totalAssignedToken}  keeps track the total assgined tokens to users
         */

    function memberExists(address member) private view returns (bool) {
        for (uint256 i = 0; i < membersAddress.length; i++) {
            if (membersAddress[i] == member) {
                return true;
            }
        }

        return false;
    }

    function getBalanceTokenForAssignment()
        external
        view
        onlyOwner
        returns (uint256)
    {
        uint256 totalToken = _token.balanceOf(address(this));
        return (totalToken - totalAssignedToken);
    }

    function assignToken(address teamMemberAddress, uint256 amount)
        external
        onlyOwner
    {
        require(
            _token != IERC20(address(0)),
            "The current address of ERC20 contract is pointing to zero address."
        );
        require(
            teamMemberAddress != address(0),
            "Cannot have zero wallet address for team member."
        );

        uint256 totalToken = _token.balanceOf(address(this));
        require(
            totalAssignedToken < totalToken,
            "No more token available for assigning."
        );

        //checks the tokens left unassigned is more than required
        require(
            (totalToken - totalAssignedToken) >= (amount),
            "Enough tokens are not available in the contract for this assignment."
        );

        teamMember[teamMemberAddress].totalTokensAssigned += amount;

        if (!memberExists(teamMemberAddress)) {
            membersAddress.push(teamMemberAddress);
        }
        totalAssignedToken += amount;
        emit TokenAssigned(teamMemberAddress, amount);
    }

    /*
    @dev Returns total tokens assigned {totalTokensAssigned}  and 
    tokens released tokensReleased{tokensReleased} to 
    the given address {teamMemberAddress}
    */

    function getTokenInfo(address teamMemberAddress)
        public
        view
        returns (uint256 totalTokensAssigned, uint256 tokensReleased)
    {
        return (
            teamMember[teamMemberAddress].totalTokensAssigned,
            teamMember[teamMemberAddress].tokensReleased
        );
    }

    /*
    @dev The is funciton checks all criteria and release the token from contract to the given address{teamMemberAddress}
    This function is private and called from release()
    */
    function releaseToken(address teamMemberAddress) private {
        //checks the amount of released token is not greater than allotted tokens
        if (
            teamMember[teamMemberAddress].tokensReleased >=
            teamMember[teamMemberAddress].totalTokensAssigned
        ) return;

        uint256 currentTime = block.timestamp;

        //checing the total percentage that can be released
        // {vestingTime}  array contain the vesting periods
        // checks which all vesting time covered and accumulate the corresponding
        //vesting percentage into {precentageToRelease}
        uint256 precentageToRelease = 0;
        for (uint8 i = 0; i < totalNumberVesting; i++) {
            if (currentTime >= vestingTime[i]) {
                precentageToRelease += vestingPercentage[i];
            } else {
                break;
            }
        }

        // {precentageToRelease} greater that zero ,then checks what all percentage in {precentageToRelease}  was
        // already released
        // and find the remaining  tokens to release {remaingToRelease}
        if (precentageToRelease > 0) {
            uint256 remaingToRelease = (teamMember[teamMemberAddress]
                .totalTokensAssigned * precentageToRelease) /
                100 -
                teamMember[teamMemberAddress].tokensReleased;

            // if {remaingToRelease} is greater than zero, the safe transfer that much amount
            // of token to the user wallet from Token contract address.
            if (remaingToRelease > 0) {
                require(
                    teamMember[teamMemberAddress].tokensReleased <
                        teamMember[teamMemberAddress].totalTokensAssigned,
                    "All tokens are already released"
                );
                teamMember[teamMemberAddress]
                    .tokensReleased += remaingToRelease;

                emit TokenReleased(teamMemberAddress, remaingToRelease);

                _token.safeTransfer(teamMemberAddress, remaingToRelease);

                return;
            } else {
                return;
            }
        } else {
            return;
        }
    }

    function release() public onlyReleaser {
        require(
            _token != IERC20(address(0)),
            "The current address of ERC20 contract is pointing to zero address."
        );
        uint256 currentTime = block.timestamp;
        //vestingTime[0] is the first time at which a percentage of token can be release
        // so the currentTime should be greater than vestingTime[0]
        require(
            currentTime >= vestingTime[0],
            "Cannot release token before the unlock period."
        );

        //bring all member address from the memberAddress array and calls teh releaseToken function
        for (uint256 i = 0; i < membersAddress.length; i++) {
            releaseToken(membersAddress[i]);
        }
    }
}
