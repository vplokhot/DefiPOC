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
    uint256 public price;
    address public coin;
    mapping(address => uint) contributions;
    ICurveFi_DepositTriCrypto2 public IDeposit;
    ITriERC20 public ITriToken;

    function setup(address _depositContract, address _triContract) external {
        IDeposit = ICurveFi_DepositTriCrypto2(_depositContract);
        ITriToken = ITriERC20(_triContract);

    }

    function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, address _receiver) external payable returns(uint256){
        console.log(msg.value, " msg value");
        for(uint i=0; i<_amounts.length; i++){
            console.log(_amounts[i]);
        }
        return IDeposit.add_liquidity{value: msg.value}(_amounts, _min_mint_amount, _receiver);
    }

    function getPool() external view returns (address) {
        return IDeposit.pool();
    }

    function getTokenBalance(address account) external view returns(uint256){
        return ITriToken.balanceOf(account);
    }
}