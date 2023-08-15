// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;
pragma abicoder v2;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IDex {
    function depositWETH(uint256 _amount) external;

    function depositUSDC(uint256 _amount) external;

    function buyWETH() external;

    function sellWETH() external;
}


contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;

    address private immutable wethAddress =
        0xCCB14936C2E000ED8393A571D15A2672537838Ad;
    address private immutable usdcAddress =
        0x65aFADD39029741B3b8f0756952C74678c9cEC93;
    address private dexContractAddress =                
        0x630cBD2F7438362f61b870B923B1B1d2ebC8BB03;

    IERC20 private weth;
    IERC20 private usdc;
    IDex private dexContract;
    
    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);

        weth = IERC20(wethAddress);
        usdc = IERC20(usdcAddress);
        dexContract = IDex(dexContractAddress);
    }

    function checkingProvider(uint _num) external pure returns (uint) {
        return _num;
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        
        dexContract.depositUSDC(1000000); // 1 USDC
        dexContract.buyWETH();
        dexContract.depositWETH(weth.balanceOf(address(this)));
        dexContract.sellWETH();
        
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

    function approveUSDC(uint256 _amount) external returns (bool) {
        return usdc.approve(dexContractAddress, _amount);
    }

    function allowanceUSDC() external view returns (uint256) {
        return usdc.allowance(address(this), dexContractAddress);
    }

    function approveWETH(uint256 _amount) external returns (bool) {
        return weth.approve(dexContractAddress, _amount);
    }

    function allowanceWETH() external view returns (uint256) {
        return weth.allowance(address(this), dexContractAddress);
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