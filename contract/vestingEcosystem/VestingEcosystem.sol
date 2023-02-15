// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/VestingMaster.sol";
import "./../vesting/Ownable.sol";
import "./../vesting/SafeERC20.sol";

//this contract is for doing vesting on Ecosystem.. which import vestingMaster contract.
//the contrac is implemented as vestingEcosystemproxy contract. Constructor of this contract contain all the initalization
//all state variable are declared is vestingStorage
//VestingEcosystem, VestingEcosystemProxy, vestingStorage are used to make upgradable contract

contract VestingEcosystem is Ownable, VestingMaster {
    constructor() VestingMaster() {}
}
