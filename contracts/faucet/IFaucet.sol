// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

interface IFaucet {
    function withdraw(address payable recipient) external returns(uint256);
}