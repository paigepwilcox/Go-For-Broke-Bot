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

    /* this is an internface that can be found in IFlashLoanSimpleReceiver.sol */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        /*since we are inheriting we need to put "override" 
        from video:
        ** we have sucessfully borrowed funds 
        ** custom logic for arbitrage */


        // set up amount owed - amount that we need to approve for the pool contract to take back
        uint256 amountOwed = amount + premium;
        // using ierc20 to pass in the asset and call the approve function as stated above
        // POOL is coming from FLashLoanSimpleReceiverBase.sol
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }
}