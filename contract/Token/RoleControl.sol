// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./Context.sol";
import "./Roles.sol";

contract RoleControl is Context {
    using Roles for Roles.Role;

    Roles.Role private _owner;
    Roles.Role private _minterBurner;
    address[] owners;
    address[] minterBurners;

    constructor() {
        _owner.add(_msgSender());
        owners.push(_msgSender());
        _minterBurner.add(_msgSender());
        minterBurners.push(_msgSender());
    }

    modifier onlyOwner() {
        require(
            isOwner(_msgSender()),
            "OwnerRole: caller does not have the Owner role"
        );
        _;
    }

    modifier onlyMinterBurner() {
        require(
            isMinterBurner(_msgSender()),
            "OwnerRole: caller does not have the MinterBurner role"
        );
        _;
    }

    function isOwner(address account) public view returns (bool) {
        return _owner.has(account);
    }

    function addOwner(address account) public onlyOwner {
        _owner.add(account);
        _owner.remove(_msgSender());
        for (uint8 i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return;
            }
        }
        owners.push(account);
    }

    function listActiveOwners()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 activeOwnerCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < owners.length; i++) {
            if (isOwner(owners[i])) {
                activeOwnerCount++;
            }
        }
        address[] memory tempOwners = new address[](activeOwnerCount);

        for (uint8 i = 0; i < owners.length; i++) {
            if (isOwner(owners[i])) {
                tempOwners[j] = owners[i];
                j++;
            }
        }

        return tempOwners;
    }

    function listInActiveOwners()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 inactiveOwnerCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < owners.length; i++) {
            if (!isOwner(owners[i])) {
                inactiveOwnerCount++;
            }
        }
        address[] memory tempOwners = new address[](inactiveOwnerCount);

        for (uint8 i = 0; i < owners.length; i++) {
            if (!isOwner(owners[i])) {
                tempOwners[j] = owners[i];
                j++;
            }
        }

        return tempOwners;
    }

    function isMinterBurner(address account) public view returns (bool) {
        return _minterBurner.has(account);
    }

    function addMinterBurner(address account) public onlyOwner {
        _minterBurner.add(account);

        for (uint8 i = 0; i < minterBurners.length; i++) {
            if (minterBurners[i] == account) {
                return;
            }
        }
        minterBurners.push(account);
    }

    function removeMinterBurner(address account) public onlyOwner {
        _minterBurner.remove(account);
        //to track history "account" is not removing from the minterBurner list
    }

    function listActiveMinterBurner()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 activeMinterBurnersCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < minterBurners.length; i++) {
            if (isMinterBurner(minterBurners[i])) {
                activeMinterBurnersCount++;
            }
        }
        address[] memory tempMinterBurners = new address[](
            activeMinterBurnersCount
        );

        for (uint8 i = 0; i < minterBurners.length; i++) {
            if (isMinterBurner(minterBurners[i])) {
                tempMinterBurners[j] = minterBurners[i];
                j++;
            }
        }

        return tempMinterBurners;
    }

    function listInActiveMinterBurner()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 inactiveMinterBurnersCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < minterBurners.length; i++) {
            if (!isMinterBurner(minterBurners[i])) {
                inactiveMinterBurnersCount++;
            }
        }
        address[] memory tempMinterBurners = new address[](
            inactiveMinterBurnersCount
        );

        for (uint8 i = 0; i < minterBurners.length; i++) {
            if (!isMinterBurner(minterBurners[i])) {
                tempMinterBurners[j] = minterBurners[i];
                j++;
            }
        }

        return tempMinterBurners;
    }
}
