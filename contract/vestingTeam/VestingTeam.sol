// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/VestingMaster.sol";

import "./../vesting/SafeERC20.sol";

//this contract is for doing vesting on Team.. which import vestingMaster contract.
//the contrac is implemented as vestingTeamproxy contract. Constructor of this contract contain all the initalization
//all state variable are declared is vestingStorage
//VestingTeam, VestingTeamProxy, vestingStorage are used to make upgradable contract

contract VestingTeam is VestingMaster {
    constructor() VestingMaster() {}
}
