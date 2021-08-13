pragma solidity ^0.8.0;

interface ICurveFi_SwapTriCrypto2 { 
    function get_virtual_price() external view returns(uint256);
    function coins(uint256 i) external view returns(address);
}