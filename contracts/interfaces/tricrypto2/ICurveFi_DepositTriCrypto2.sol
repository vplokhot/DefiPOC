pragma solidity ^0.8.0;

interface ICurveFi_DepositTriCrypto2 { 
    function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, address _receiver) external payable returns(uint256);
    function remove_liquidity(uint256 _amount, uint256[3] calldata _min_amounts, address _receiver) external returns(uint256[3] memory);
    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount, address _receiver) external returns(uint256);
    function pool() external view returns(address);
    function token() external view returns(address);


}