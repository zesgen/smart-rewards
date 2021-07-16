// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "../../interfaces/IRandomProvider.sol";

contract Randomable is OwnableUpgradeable {
    address private _randomProvider;

    event RandomProviderChanged(address indexed randomProvider);

    function __Randomable_init(address randomProvider_) internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Randomable_init_unchained(randomProvider_);
    }

    function __Randomable_init_unchained(address randomProvider_) internal initializer {
        setRandomProvider(randomProvider_);
    }

    /**
     * @dev Requests and returns random number form random provider.
     */
    function _getRandomness() internal view returns(uint256) {
        return IRandomProvider(_randomProvider).getRandomness();
    }

    /**
     * @dev Sets `randomProvider` address. Can only be called by the contract owner.
     * Emits an {RandomProviderChanged} event.
     */
    function setRandomProvider(address newRandomProvider) public onlyOwner {
        // Fail if `newRandomProvider` doesn't implement IRandomProvider interface.
        IRandomProvider(newRandomProvider).getRandomness();
        _randomProvider = newRandomProvider;
        emit RandomProviderChanged(_randomProvider);
    }

    /**
     * @dev Returns `randomProvider` address.
     */
    function getRandomProvider() external view returns(address) {
        return _randomProvider;
    }
}