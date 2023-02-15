// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/VestingStorage.sol";

//all state variables of team is initalised in this contract
//
contract VestingAdvisorsproxy is VestingStorage {
    address public vestingAdvisorsaddress;

    constructor(address _VestingAdvisorsaddress) {
        require(
            _VestingAdvisorsaddress != address(0),
            "Zero address given for vesting"
        );
        vestingAdvisorsaddress = _VestingAdvisorsaddress;
        _owner = msg.sender;

        uint256[] memory _vestingTime = new uint256[](16);
        _vestingTime[0] = 1680300000; //  31 March 2023 10:00:00 PM
        _vestingTime[1] = 1688162400; //30 June 2023 10:00:00 PM
        _vestingTime[2] = 1696111200; //30 September 2023 10:00:00 PM
        _vestingTime[3] = 1704060000; //31 December 2023 10:00:00 PM
        _vestingTime[4] = 1706738400; //31 January 2024 10:00:00 PM
        _vestingTime[5] = 1709244000; //29 February 2024 10:00:00 PM
        _vestingTime[6] = 1711922400; //31 March 2024 10:00:00 PM
        _vestingTime[7] = 1714514400; //30 April 2024 10:00:00 PM
        _vestingTime[8] = 1717192800; //31 May 2024 10:00:00 PM
        _vestingTime[9] = 1719784800; //30 June 2024 10:00:00 PM
        _vestingTime[10] = 1722463200; //31 July 2024 10:00:00 PM
        _vestingTime[11] = 1725141600; //31 August 2024 10:00:00 PM
        _vestingTime[12] = 1727733600; //30 September 2024 10:00:00 PM
        _vestingTime[13] = 1730412000; //31 October 2024 10:00:00 PM
        _vestingTime[14] = 1733004000; //30 November 2024 10:00:00 PM
        _vestingTime[15] = 1735682400; //31 December 2024 10:00:00 PM
        //% of vesting after each vestingtime in above dates

        uint8[] memory _vestingPercentage = new uint8[](16);
        _vestingPercentage[0] = 10;
        _vestingPercentage[1] = 10;
        _vestingPercentage[2] = 10;
        _vestingPercentage[3] = 10;
        _vestingPercentage[4] = 5;
        _vestingPercentage[5] = 5;
        _vestingPercentage[6] = 5;
        _vestingPercentage[7] = 5;
        _vestingPercentage[8] = 5;
        _vestingPercentage[9] = 5;
        _vestingPercentage[10] = 5;
        _vestingPercentage[11] = 5;
        _vestingPercentage[12] = 5;
        _vestingPercentage[13] = 5;
        _vestingPercentage[14] = 5;
        _vestingPercentage[15] = 5;

        uint8 _totalNumberVesting = 16;

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
        require(
            child != address(0),
            "Cannot give zero address for vesting contract."
        );
        vestingAdvisorsaddress = child;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Fallback                                  */
    /* -------------------------------------------------------------------------- */
    //call back to actual contract vestingAdvisors
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
        _delegate(vestingAdvisorsaddress);
    }
}
