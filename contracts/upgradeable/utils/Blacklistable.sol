// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title Blacklistable Token
 * @dev Allows accounts to be blacklisted by a "blacklister" role
 */
contract Blacklistable is OwnableUpgradeable {
    address private _blacklister;
    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed account);
    event UnBlacklisted(address indexed account);
    event SelfBlacklisted(address indexed account);
    event BlacklisterChanged(address indexed newBlacklister);

    function __Blacklistable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Blacklistable_init_unchained();
    }

    function __Blacklistable_init_unchained() internal initializer {
    }

    /**
     * @dev Throws if called by any account other than the blacklister
     */
    modifier onlyBlacklister() {
        require(
            msg.sender == _blacklister,
            "Blacklistable: caller is not the blacklister"
        );
        _;
    }

    /**
     * @dev Throws if argument account is blacklisted
     * @param account The address to check
     */
    modifier notBlacklisted(address account) {
        require(
            !blacklisted[account],
            "Blacklistable: account is blacklisted"
        );
        _;
    }

    function getBlacklister() external view returns (address) {
        return _blacklister;
    }

    /**
     * @dev Checks if account is blacklisted
     * @param account The address to check
     */
    function isBlacklisted(address account) external view returns (bool) {
        return blacklisted[account];
    }

    /**
     * @dev Adds account to blacklist
     * @param account The address to blacklist
     */
    function blacklist(address account) external onlyBlacklister {
        blacklisted[account] = true;
        emit Blacklisted(account);
    }

    /**
     * @dev Removes account from blacklist
     * @param account The address to remove from the blacklist
     */
    function unBlacklist(address account) external onlyBlacklister {
        blacklisted[account] = false;
        emit UnBlacklisted(account);
    }

    function setBlacklister(address newBlacklister) external onlyOwner {
        require(
            newBlacklister != address(0),
            "Blacklistable: new blacklister is the zero address"
        );
        _blacklister = newBlacklister;
        emit BlacklisterChanged(_blacklister);
    }

    /**
     * @dev Adds msg.sender to blacklist (self-blacklist)
     */
    function selfBlacklist() external {
        blacklisted[msg.sender] = true;
        emit Blacklisted(msg.sender);
        emit SelfBlacklisted(msg.sender);
    }
}