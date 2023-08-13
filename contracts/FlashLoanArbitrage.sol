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

    function depositMAGIC(uint256 _amount) external;

    function buyMAGIC() external;

    function sellMAGIC() external;
}


contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;

    address private immutable wethAddress =
        0x7649e0d153752c556b8b23DB1f1D3d42993E83a5;
    address private immutable magicAddress =
        0x8Be59D90A7Dc679C5cE5a7963cD1082dAB499918;
    address private dexContractAddress =                
        0x51A7314feD7612f8fc635FFF3D5b37A64C2688aE;

    IERC20 private weth;
    IERC20 private magic;
    IDex private dexContract;
    

    constructor(address _addressProvider) 
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
        owner = payable(msg.sender);

        weth = IERC20(wethAddress);
        magic = IERC20(magicAddress);
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
        
        dexContract.depositWETH(1000000000); // 1000 USDC
        dexContract.buyMAGIC();
        dexContract.depositMAGIC(magic.balanceOf(address(this)));
        dexContract.sellMAGIC();
        
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