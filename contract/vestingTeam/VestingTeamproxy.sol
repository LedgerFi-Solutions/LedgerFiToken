// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/AccessControl.sol";

//all state variables of team is initalised in this contract
//
contract VestingTeamproxy is AccessControl {
    address public vestingTeamaddress;

    constructor(address _VestingTeamaddress) AccessControl() {
        require(
            _VestingTeamaddress != address(0),
            "Zero address given for vesting"
        );
        vestingTeamaddress = _VestingTeamaddress;

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

    //function for upgradable contract
    function updateContractAddress(address child) external onlyOwner {
        require(
            child != address(0),
            "Cannot give zero address for vesting contract."
        );
        vestingTeamaddress = child;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Fallback                                  */
    /* -------------------------------------------------------------------------- */
    //call back to actual contract vestingTeam
    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(
                gas(),
                implementation,
                0,
                calldatasize(),
                0,
                0
            )

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    fallback() external {
        _delegate(vestingTeamaddress);
    }
}
