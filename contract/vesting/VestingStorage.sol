// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./SafeERC20.sol";

contract VestingStorage {
    using SafeERC20 for IERC20;

    // ERC20 LFT token contract being held
    IERC20 _token;

    //total vesting periods
    uint8 public totalNumberVesting;

    //Unix time stamp which represent each vesting time. Tokens are releasing based on the vesting time
    uint256[] public vestingTime;

    //% of tokens that can be released against each vesting time.
    //the length of {vestingTime} and {vestingPercentage} must be equal
    uint8[] public vestingPercentage;

    //{totalNumberVesting} , {vestingTime} and {vestingPercentage} are initialsed in the proxy contract
    //which imports the storage contract

    address[] public membersAddress;
    uint256 totalAssignedToken;

    struct TokenDetails {
        uint256 totalTokensAssigned; //total tokens got at the time of presale
        uint256 tokensReleased; // how many tokens unlocked
    }

    mapping(address => TokenDetails) public teamMember;
    address internal _owner;
    address public triggeringWallet;
}
