// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;
import "./../vesting/VestingStorage.sol";

//all state variables of team is initalised in this contract
//
contract VestingPMLproxy is VestingStorage {
    address public vestingPMLaddress;

    constructor(address _VestingPMLaddress) {
        require(
            _VestingPMLaddress != address(0),
            "Zero address given for vesting"
        );
        vestingPMLaddress = _VestingPMLaddress;
        _owner = msg.sender;

        uint256[] memory _vestingTime = new uint256[](10);
        _vestingTime[0] = 1680300000; //  31 March 2023 10:00:00 PM
        _vestingTime[1] = 1688162400; //30 June 2023 10:00:00 PM
        _vestingTime[2] = 1696111200; //30 September 2023 10:00:00 PM
        _vestingTime[3] = 1704060000; //31 December 2023 10:00:00 PM
        _vestingTime[4] = 1711922400; //31 March 2024 10:00:00 PM
        _vestingTime[5] = 1719784800; //30 June 2024 10:00:00 PM
        _vestingTime[6] = 1727733600; //30 September 2024 10:00:00 PM
        _vestingTime[7] = 1735682400; //31 December 2024 10:00:00 PM
        _vestingTime[8] = 1743458400; //31 March 2025 10:00:00 PM
        _vestingTime[9] = 1751320800; //30 June 2025 10:00:00 PM
        //% of vesting after each vestingtime in above dates

        uint8[] memory _vestingPercentage = new uint8[](10);
        _vestingPercentage[0] = 10;
        _vestingPercentage[1] = 10;
        _vestingPercentage[2] = 10;
        _vestingPercentage[3] = 10;
        _vestingPercentage[4] = 10;
        _vestingPercentage[5] = 10;
        _vestingPercentage[6] = 10;
        _vestingPercentage[7] = 10;
        _vestingPercentage[8] = 10;
        _vestingPercentage[9] = 10;

        uint8 _totalNumberVesting = 10;

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
        vestingPMLaddress = child;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Fallback                                  */
    /* -------------------------------------------------------------------------- */
    //call back to actual contract vestingPML
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
        _delegate(vestingPMLaddress);
    }
}
