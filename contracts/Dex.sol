// contracts/FlashLoan.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    address payable public owner;

    // Aave ERC20 Token addresses on Goerli network
    address private immutable wethAddress =
        0xCCB14936C2E000ED8393A571D15A2672537838Ad;
    address private immutable usdcAddress =
        0x65aFADD39029741B3b8f0756952C74678c9cEC93;

    IERC20 private weth;
    IERC20 private usdc;

    // exchange rate indexes
    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    // keeps track of individuals' weth balances
    mapping(address => uint256) public wethBalances;

    // keeps track of individuals' USDC balances
    mapping(address => uint256) public usdcBalances;

    constructor() {
        owner = payable(msg.sender);
        weth = IERC20(wethAddress);
        usdc = IERC20(usdcAddress);
    }

    /// Deposit USDCS tokens into contract.
    /// @param _amount amount to be transfered into this contract which serves as a simulated exchange 
    /// @dev use .allowance() to allow your contract to accept funds from 'msg.sender' and transferFrom() to execute transaction
    function depositUSDC(uint256 _amount) external {
        usdcBalances[msg.sender] += _amount;
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the usdc token allowance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    /// Deposits WETH tokens into contract.
    /// @param _amount amount to be transfered into this contract which serves as a simulated exchange 
    /// @dev use .allowance() to allow your contract to accept funds from 'msg.sender' and transferFrom() to execute transaction
    function depositWETH(uint256 _amount) external {
        wethBalances[msg.sender] += _amount;
        uint256 allowance = weth.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the weth token allowance");
        weth.transferFrom(msg.sender, address(this), _amount);
    }

    /// Transfers USDC for WETH from this contract to `msg.sender`
    function buyWETH() external {
        uint256 wethToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) *
            (10**12);
        weth.transfer(msg.sender, wethToReceive);
    }

    /// Transfers WETH for USDC from this contract to `msg.sender`
    function sellWETH() external {
        uint256 usdcToReceive = ((wethBalances[msg.sender] * dexBRate) / 100) /
            (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    /// Gets the balance of a token within a contract
    /// @param _tokenAddress address of a standard ERC20 token 
    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    /// Allows the owner to withdraw a token into `msg.sender`
    /// @param _tokenAddress address of a standard ERC20 token
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    /// Modifer that allows functions to be called only by the `msg.sender`
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    /// Allows this contract to receive funds
    receive() external payable {}
}
