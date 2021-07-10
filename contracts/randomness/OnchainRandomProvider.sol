// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "./IRandomProvider.sol";

contract OnchainRandomProvider is IRandomProvider {
    /**
     * @dev Returns (pseudo) random number.
     */
    function getRandomness() override external view returns(uint256) {
         return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, tx.origin)));
    }
}