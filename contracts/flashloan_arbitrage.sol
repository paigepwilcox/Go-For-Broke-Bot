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


    // write a function that will kick off entire process and request the loan
    function requestFlashLoanArbitrage(address _token, uint256 _amount) public {
        // set to the adress of the current contract
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        // found in IPool.sol 459
        // getting rid of types since these are params now
        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }
    
    /*
    * use this at the very end to see what the balance of our contract is
    * external defines a type of function that can only be called outside the contract by other contracts
    * view defines a function that reads state variables but does not alter them
     */
    function getBalance(address _tokenAddress) external view returns (uint256) {
        // instantiate with _tokenAddress
        // gives us this contracts balance of any token we specify 
        return IERC20(_tokenAddress).balanceOf(address(this));
    }


    // need a function to withdraw our profit funds
    // designed to withdraw specific tokens
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);

        /*
        * initiate transfer on this token object
        * msg.sender is the owner of the contract 
        * token.balanceOf -- all the holdings of this contract for this particular token */
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    // adding an only owner modifier
    modifier onlyOwner() {}
}