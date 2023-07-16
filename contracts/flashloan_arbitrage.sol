// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
/* flashloansimplereceiverbase - we need to implement this interface for our contract to be a receiver of a loan. contains the executeOperation() */
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
/* IPoolAdressesProvider is called within our flashloansimplereceiverbase */
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
/* need IERC20 to call the approve function on the token we are borrowing */


contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;
    // an address type variable that allows owner to receive ether to a contract

    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
    }
}