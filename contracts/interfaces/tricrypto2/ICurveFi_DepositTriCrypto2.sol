pragma solidity ^0.8.0;

interface ICurveFi_DepositTriCrypto2 { 
    function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, address _receiver) external payable returns(uint256);
}