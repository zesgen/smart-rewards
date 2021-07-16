// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { IERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import { SafeERC20Upgradeable } from "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";

abstract contract Rescuable is OwnableUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;

    address private _rescuer;

    event RescuerChanged(address indexed newRescuer);

    function __Rescuable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
        __Rescuable_init_unchained();
    }

    function __Rescuable_init_unchained() internal initializer {
    }

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
        IERC20Upgradeable tokenContract,
        address to,
        uint256 amount
    ) external onlyRescuer {
        tokenContract.safeTransfer(to, amount);
    }
}