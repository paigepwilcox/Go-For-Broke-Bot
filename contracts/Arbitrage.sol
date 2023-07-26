pragma solidity 0.8.18;
pragma abicoder v2;

// arbitrage uniswap 
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';




contract ArbitrageOperation {
    ISwapRouter public immutable swapRouter;
    address public constant USDC = "0x65aFADD39029741B3b8f0756952C74678c9cEC93";
    address public constant WETH9 = "0xCCB14936C2E000ED8393A571D15A2672537838Ad";

    // setting pool fee 
    uint24 public constant poolFee = 3000;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    function swapDualTrade(uint256 amountIn) external return (uint256 amountOut) {

        TransferHelper.safeTransferFrom(USDC, msg.sender)
    }

}
