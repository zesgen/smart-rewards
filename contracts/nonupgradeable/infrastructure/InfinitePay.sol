// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;


import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from  "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import { Context } from  "@openzeppelin/contracts/utils/Context.sol";

contract InfinitePay is Context {
    using SafeERC20 for IERC20;

    // TODO Set correct token address before deployment
    address constant public token = 0x0000000000000000000000000000000000000000;

    event Transfer(address indexed from, address indexed to, uint256 amount, string guid);

    function transfer(address to, uint256 amount, string memory guid) external {
        IERC20(token).safeTransferFrom(_msgSender(), to, amount);
        emit Transfer(_msgSender(), to, amount, guid);
    }
}