pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../interfaces/tricrypto2/ICurveFi_DepositTriCrypto2.sol";
import "../interfaces/tricrypto2/ITriERC20.sol";




contract TriPool_Deposit is Initializable, Context, Ownable{

    using SafeMath for uint256;
    ICurveFi_DepositTriCrypto2 public IDeposit;
    ITriERC20 public ITriToken;

    function setup(address _depositContract, address _triContract) external {
        IDeposit = ICurveFi_DepositTriCrypto2(_depositContract);
        ITriToken = ITriERC20(_triContract);

    }

    function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, address _receiver) external payable returns(uint256){
        return IDeposit.add_liquidity{value: msg.value}(_amounts, _min_mint_amount, address(this));
    }

    function remove_liquidity(uint256 _amount, uint256[3] calldata _min_amounts, address _receiver) external returns(uint256[3] memory){
        return IDeposit.remove_liquidity(_amount, _min_amounts, _receiver);
    }

    function remove_liquidity_one_coin(uint256 _token_amount, uint256 i, uint256 _min_amount, address _receiver) external returns(uint256){
        // ITriToken.approve(0x3993d34e7e99Abf6B6f367309975d1360222D446, 0);
        ITriToken.approve(0x3993d34e7e99Abf6B6f367309975d1360222D446, _token_amount);
        
        return IDeposit.remove_liquidity_one_coin(_token_amount, i, _min_amount, _receiver);
    }

    function getPool() external view returns (address) {
        return IDeposit.pool();
    }

    function getTokenBalance(address account) external view returns(uint256){
        return ITriToken.balanceOf(account);
    }

    receive() external payable{}
}