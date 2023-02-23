// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./Context.sol";
import "./Roles.sol";
import "./VestingStorage.sol";

contract RoleControl is Context, VestingStorage {
    using Roles for Roles.Role;

    Roles.Role _owner;
    Roles.Role _releaserWallet;

    constructor() {
        _owner.add(_msgSender());
        owners.push(_msgSender());
        _releaserWallet.add(_msgSender());
        releasers.push(_msgSender());
    }

    modifier onlyOwner() {
        require(
            isOwner(_msgSender()),
            "OwnerRole: caller does not have the Owner role"
        );
        _;
    }

    modifier onlyReleaser() {
        require(
            isReleaser(_msgSender()),
            "OwnerRole: caller does not have the  Releaser role"
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

    function isReleaser(address account) public view returns (bool) {
        return _releaserWallet.has(account);
    }

    function addReleaser(address account) public onlyOwner {
        _releaserWallet.add(account);

        for (uint8 i = 0; i < releasers.length; i++) {
            if (releasers[i] == account) {
                return;
            }
        }
        releasers.push(account);
    }

    function removeReleaser(address account) public onlyOwner {
        _releaserWallet.remove(account);
    }

    function listActiveReleasers()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 activeReleasersCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < releasers.length; i++) {
            if (isReleaser(releasers[i])) {
                activeReleasersCount++;
            }
        }
        address[] memory tempReleasers = new address[](activeReleasersCount);

        for (uint8 i = 0; i < releasers.length; i++) {
            if (isReleaser(releasers[i])) {
                tempReleasers[j] = releasers[i];
                j++;
            }
        }

        return tempReleasers;
    }

    function listInActiveReleasers()
        public
        view
        onlyOwner
        returns (address[] memory)
    {
        uint8 inactiveReleasersCount = 0;
        uint8 j = 0;
        for (uint8 i = 0; i < releasers.length; i++) {
            if (!isReleaser(releasers[i])) {
                inactiveReleasersCount++;
            }
        }
        address[] memory tempReleasers = new address[](inactiveReleasersCount);

        for (uint8 i = 0; i < releasers.length; i++) {
            if (!isReleaser(releasers[i])) {
                tempReleasers[j] = releasers[i];
                j++;
            }
        }

        return tempReleasers;
    }
}
