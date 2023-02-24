// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/VestingMaster.sol";

import "./../vesting/SafeERC20.sol";

//this contract is for doing vesting on Marketing.. which import vestingMaster contract.
//the contrac is implemented as vestingMarketingproxy contract. Constructor of this contract contain all the initalization
//all state variable are declared is vestingStorage
//VestingMarketing, VestingMarketingProxy, vestingStorage are used to make upgradable contract

contract VestingMarketing is VestingMaster {
    constructor() VestingMaster() {}
}
