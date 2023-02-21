// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./Context.sol";
import "./Roles.sol";

contract AccessControl is Context {
    using Roles for Roles.Role;

    Roles.Role private _owner;
    Roles.Role private _minterBurner;

    constructor() {
        _owner.add(_msgSender());
        _minterBurner.add(_msgSender());
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
    }

    function removeOwner(address account) public onlyOwner {
        require(account != _msgSender(), "You cant remove your own ownership");
        _owner.remove(account);
    }

    function isMinterBurner(address account) public view returns (bool) {
        return _minterBurner.has(account);
    }

    function addMinterBurner(address account) public onlyOwner {
        _minterBurner.add(account);
    }

    function removeMinterBurner(address account) public onlyOwner {
        _minterBurner.remove(account);
    }
}
