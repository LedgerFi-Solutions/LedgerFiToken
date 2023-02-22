// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./Context.sol";
import "./Roles.sol";

contract RoleControl is Context, Roles {
    constructor() {
        add(_owner, _msgSender());
        owners.push(_msgSender());
        add(_releaserWallet, _msgSender());
        releasers.push(_msgSender());
    }

    modifier onlyOwner() {
        require(
            isOwner(_msgSender()),
            "OwnerRole:- caller does not have the Owner role"
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
        return has(_owner, account);
    }

    function addOwner(address account) public onlyOwner {
        add(_owner, account);
        for (uint8 i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return;
            }
        }
        owners.push(account);
    }

    function removeOwner(address account) public onlyOwner {
        require(account != _msgSender(), "You cant remove your own ownership");
        remove(_owner, account);
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
        return has(_releaserWallet, account);
    }

    function addReleaser(address account) public onlyOwner {
        add(_releaserWallet, account);

        for (uint8 i = 0; i < releasers.length; i++) {
            if (releasers[i] == account) {
                return;
            }
        }
        releasers.push(account);
    }

    function removeReleaser(address account) public onlyOwner {
        remove(_releaserWallet, account);
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
