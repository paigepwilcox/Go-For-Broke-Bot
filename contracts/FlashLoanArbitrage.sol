// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;
pragma abicoder v2;

// arbitrage uniswap 
// import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
// import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
interface IUniswapV2Router {
// https://docs.uniswap.org/contracts/v2/reference/smart-contracts/library#getamountsout
    function getAmountsOut(uint256 amountIn, address[] memory path) external view returns (uint256[] memory amounts); // returns the maximum output amount of the other asset (accounting for fees) given reserves.
    function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external returns (uint256[] memory amounts); 
}
interface IUniswapV2Pair {
// https://docs.uniswap.org/contracts/v2/reference/smart-contracts/pair#swap-1
  function swap(uint256 amount0Out,	uint256 amount1Out,	address to,	bytes calldata data) external; // swaps token emits swap, sync
}



contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;
    // address router1 = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    // address router2 = 0xc35DADB65012eC5796536bD9864eD8773aBc74C4;
    // address token1 = 0x0B1ba0af832d7C05fD64161E0Db78E85978E8082;
    // address token2 = 0x753198790D8B64eCa2A83B9Af99b6e79A018A74b;
    
    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);
    }

    function checkingProvider(uint _num) external pure returns (uint) {
        return _num;
    }

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

    /* this is an interface that can be found in IFlashLoanSimpleReceiver.sol */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        
        uint startBalance = IERC20(token1).balanceOf(address(this));
        uint token2InitialBalance = IERC20(token2).balanceOf(address(this));
        swap(router1, token1, token2, amount);
        uint token2Balance = IERC20(token2).balanceOf(address(this));
        uint availableFunds = token2Balance - token2InitialBalance;
        swap(router2, token2, token1, availableFunds);
        uint endBalance = IERC20(token1).balanceOf(address(this));
        require(endBalance > startBalance, "reverted, you're broke");

        
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) external onlyOwner {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }
    
    function getBalance(address _tokenAddress) external view returns (uint256) { 
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }
    //The receive function is similar to the fallback function, but it is designed specifically to handle incoming ether without the need for a data call.
    receive() external payable {}
}