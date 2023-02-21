// SPDX-License-Identifier: MIT

pragma solidity 0.8.16;
import "./Context.sol";
import "./Roles.sol";

contract AccessControl is Context, Roles {
    constructor() {
        add(_owner, _msgSender());
        add(_releaserWallet, _msgSender());
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
    }

    function removeOwner(address account) public onlyOwner {
        require(account != _msgSender(), "You cant remove your own ownership");
        remove(_owner, account);
    }

    function isReleaser(address account) public view returns (bool) {
        return has(_releaserWallet, account);
    }

    function addReleaser(address account) public onlyOwner {
        add(_releaserWallet, account);
    }

    function removeReleaser(address account) public onlyOwner {
        remove(_releaserWallet, account);
    }
}
