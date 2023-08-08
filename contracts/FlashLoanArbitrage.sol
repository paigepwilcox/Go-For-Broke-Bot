// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
pragma abicoder v2;

// arbitrage uniswap 
// import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
// import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
/* 
flashloansimplereceiverbase - we need to implement this interface for our contract to be a receiver of a loan. contains the executeOperation() 
*/
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";

import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
/* 
IPoolAdressesProvider is called within our flashloansimplereceiverbase
* what are we using from this import?
*/
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
/* 
IERC20 is an interface 
* what are we using from this import? calling the approve function on the token we are borrowing 
*/
interface IUniswapV2Router {
// https://docs.uniswap.org/contracts/v2/reference/smart-contracts/library#getamountsout
    function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts); // returns the maximum output amount of the other asset (accounting for fees) given reserves.
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts); 
}



contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase, Ownable {
    // address payable owner;
    address router1;
    address router2;
    address token1;
    address token2;

    // i think i have to make these state variable to be able to update their values
    
    /* 
    * an address type variable named owner, payable allows owner to receive ether to a contract
    * When a developer explicitly marks a smart contract with the payable type, they are saying “I expect ether to be sent to this function”. 
    */


    /* 
    * a constructor function is used to initialize state variables of a contract 
    * a contract has only one constructor
    * since this contract is inheriting from FlashLoanSimpleReceiverBase the constructor is initializing an instance of this contract */
    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        // we are assigning owner to the address that deploys this contract
        // owner = payable(msg.sender);

        token2 = 0x753198790D8B64eCa2A83B9Af99b6e79A018A74b;
        token1 = 0x0B1ba0af832d7C05fD64161E0Db78E85978E8082;
        router2 = 0xc35DADB65012eC5796536bD9864eD8773aBc74C4;
        router1 = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    }
    /* to instantiate an instance of the IPoolAdressesProvider interface we pass in -- FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) */



    function swap(address router, address _tokenIn, address _tokenOut, uint256 _amount) private {
        IERC20(_tokenIn).approve(router, _amount);
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        uint deadline = block.timestamp + 300;
        IUniswapV2Router(router).swapExactTokensForTokens(_amount, 1, path, address(this), deadline);
    }

    // returns the amount left of _tokenOut after a single swap 
    function getAmountOutMin(address router, address _tokenIn, address _tokenOut, uint256 _amount) public view returns (uint256) {
        address[] memory path;
        path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;
        uint256[] memory amountOutMins = IUniswapV2Router(router).getAmountsOut(_amount, path);
        return amountOutMins[path.length -1];
    }

    function estimateDualTrade(address _router1, address _router2, address _token1, address _token2, uint256 _amount) external view returns (uint256)  {
        uint256 amtBack1 = getAmountOutMin(_router1, _token1, _token2, _amount);
        uint256 amtBack2 = getAmountOutMin(_router2, _token2, _token1, amtBack1);
        return amtBack2;
    }

    function dualTradePath(address _router1, address _router2, address _token1, address _token2) external onlyOwner {
        router1 = _router1;
        router2 = _router2;
        token1 = _token1;
        token2 = _token2;
    }
    /* this is an interface that can be found in IFlashLoanSimpleReceiver.sol */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override onlyOwner returns (bool) {
        /*since we are inheriting we need to put "override" 

        ** at this point in our code we have sucessfully borrowed funds 
        ** custom logic for arbitrage */
        uint startBalance = IERC20(token1).balanceOf(address(this));
        uint token2InitialBalance = IERC20(token2).balanceOf(address(this));
        swap(router1, token1, token2, amount);
        uint token2Balance = IERC20(token2).balanceOf(address(this));
        uint availableFunds = token2Balance - token2InitialBalance;
        swap(router2, token2, token1, availableFunds);
        uint endBalance = IERC20(token1).balanceOf(address(this));
        require(endBalance > startBalance, "reverted, you're broke");

        // set up amount owed - amount that we need to approve for the pool contract to take back
        uint256 amountOwed = amount + premium;
        // using ierc20 to pass in the asset and call the approve function as stated above
        // POOL is coming from FLashLoanSimpleReceiverBase.sol
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
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

    //The receive function is similar to the fallback function, but it is designed specifically to handle incoming ether without the need for a data call.
    receive() external payable {}
}