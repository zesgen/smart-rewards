// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

abstract contract Rescuable is Ownable {
    using SafeERC20 for IERC20;

    address private _rescuer;

    event RescuerChanged(address indexed newRescuer);

    /**
     * @notice Revert if called by any account other than the rescuer.
     */
    modifier onlyRescuer() {
        require(getRescuer() == _msgSender(), "Rescuable: caller is not the rescuer");
        _;
    }

    /**
     * @notice Returns current rescuer
     * @return Rescuer's address
     */
    function getRescuer() public view virtual returns (address) {
        return _rescuer;
    }

    /**
     * @notice Assign the rescuer role to a given address.
     * @param newRescuer New rescuer's address
     */
    function setRescuer(address newRescuer) external onlyOwner {
        _rescuer = newRescuer;
        emit RescuerChanged(newRescuer);
    }

    /**
     * @notice Rescue ERC20 tokens locked up in this contract.
     * @param tokenContract ERC20 token contract address
     * @param to Recipient address
     * @param amount Amount to withdraw
     */
    function rescueERC20(
        IERC20 tokenContract,
        address to,
        uint256 amount
    ) external onlyRescuer {
        tokenContract.safeTransfer(to, amount);
    }
}