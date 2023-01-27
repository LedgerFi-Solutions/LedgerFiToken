// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./VestingTeamStorage.sol";

//all state variables of team is initalised in this contract
//
contract VestingTeamproxy is VestingTeamStorage {
    address public vestingTeamaddress;

    constructor(address _VestingTeamaddress) {
        require(
            _VestingTeamaddress != address(0),
            "Zero address givne for vesintg"
        );
        vestingTeamaddress = _VestingTeamaddress;
        _owner = msg.sender;

        //time period for vesting
        //already defined in the document
        //dec 31 11:59:59pm   2023,2024,2025,2026,2027,2028,2029 .. corresponding data is given below
        uint256[] memory _vestingTime = new uint256[](7);
        _vestingTime[0] = 1704067199; //dec 31 11:59:59pm   2023
        _vestingTime[1] = 1735689599; //dec 31 11:59:59pm   2024
        _vestingTime[2] = 1767225599;
        _vestingTime[3] = 1798761599;
        _vestingTime[4] = 1830297599;
        _vestingTime[5] = 1861919999;
        _vestingTime[6] = 1893455999;

        //% of vesting after each vestingtime in above dates

        uint8[] memory _vestingPercentage = new uint8[](7);
        _vestingPercentage[0] = 10; // % on dec 31 11:59:59pm   2023
        _vestingPercentage[1] = 10; //% on dec 31 11:59:59pm   2024
        _vestingPercentage[2] = 10;
        _vestingPercentage[3] = 10;
        _vestingPercentage[4] = 10;
        _vestingPercentage[5] = 25;
        _vestingPercentage[6] = 25;

        uint8 _totalNumberVesting = 7;

        vestingTime = _vestingTime;
        vestingPercentage = _vestingPercentage;
        totalNumberVesting = _totalNumberVesting;
    }

    modifier restricted() {
        require(
            msg.sender == _owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    //function for upgradable contract
    function updateContractAddress(address child) external restricted {
        require(child != address(0), "Zero address givne for vesintg");
        vestingTeamaddress = child;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Fallback                                  */
    /* -------------------------------------------------------------------------- */
    //call back to actual contract vestingTeam
    fallback() external {
        address _impl = vestingTeamaddress;
        assembly {
            // Check if adress not 0x0
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }
}
