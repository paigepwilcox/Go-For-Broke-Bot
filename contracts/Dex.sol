// contracts/FlashLoan.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    address payable public owner;

    // Aave ERC20 Token addresses on Goerli network
    address private immutable wethAddress =
        0x7649e0d153752c556b8b23DB1f1D3d42993E83a5;
    address private immutable magicAddress =
        0x8Be59D90A7Dc679C5cE5a7963cD1082dAB499918;

    IERC20 private weth;
    IERC20 private magic;

    // exchange rate indexes
    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    // keeps track of individuals' weth balances
    mapping(address => uint256) public wethBalances;

    // keeps track of individuals' magic balances
    mapping(address => uint256) public magicBalances;

    constructor() {
        owner = payable(msg.sender);
        weth = IERC20(wethAddress);
        magic = IERC20(magicAddress);
    }

    function depositWETH(uint256 _amount) external {
        wethBalances[msg.sender] += _amount;
        uint256 allowance = weth.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        weth.transferFrom(msg.sender, address(this), _amount);
    }

    function depositMAGIC(uint256 _amount) external {
        magicBalances[msg.sender] += _amount;
        uint256 allowance = magic.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        magic.transferFrom(msg.sender, address(this), _amount);
    }

    function buyMAGIC() external {
        uint256 magicToReceive = ((wethBalances[msg.sender] / dexARate) * 100) *
            (10**12);
        magic.transfer(msg.sender, magicToReceive);
    }

    function sellMAGIC() external {
        uint256 wethToReceive = ((magicBalances[msg.sender] * dexBRate) / 100) /
            (10**12);
        weth.transfer(msg.sender, wethToReceive);
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

    receive() external payable {}
}
