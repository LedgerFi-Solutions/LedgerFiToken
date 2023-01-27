// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./VestingMaster.sol";
import "./Ownable.sol";
import "./SafeERC20.sol";

//this contract is for doing vesting on Team.. which import vestingMaster contract.
//the contrac is implemented as vestingTeamproxy contract. Constructor of this contract contain all the initalization
//all state variable are declared is vestingTeamStorage
//VestingTeam, VestingTeamProxy, vestingTeamStorage are used to make upgradable contract

contract VestingTeam is Ownable, VestingMaster {
    constructor() VestingMaster() {}
}
