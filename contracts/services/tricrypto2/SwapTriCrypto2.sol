pragma solidity ^0.8.0;
import "hardhat/console.sol";

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../../interfaces/tricrypto2/ICurveFi_SwapTriCrypto2.sol";
import "../../interfaces/tricrypto2/ICurveFi_DepositTriCrypto2.sol";



contract SwapTriCrypto2 is Initializable, Context, Ownable{

    using SafeMath for uint256;
    uint256 public price;
    address public coin;
    mapping(address => uint) contributions;
    ICurveFi_DepositTriCrypto2 private IDeposit;

    function setup(address _swapContract, address _depositContract) external {
        require(_swapContract != address(0), "Incorrect deposit contract address");
        price = ICurveFi_SwapTriCrypto2(_swapContract).get_virtual_price();
        coin = ICurveFi_SwapTriCrypto2(_swapContract).coins(uint256(2));
        IDeposit = ICurveFi_DepositTriCrypto2(_depositContract);
    }


    function getDeposit() external view returns(ICurveFi_DepositTriCrypto2) {
        return IDeposit;
    }

    function add_liquidity(uint256[3] calldata _amounts, uint256 _min_mint_amount, address _receiver) external{
        for(uint i=0; i<_amounts.length; i++ ){
            console.log(_amounts[i]);
        }
        IDeposit.add_liquidity{value: address(this).balance}(_amounts, _min_mint_amount, _receiver);
    }

    function deposit() external payable{
        contributions[msg.sender] += msg.value;
    }

    function getBalance(address x) external view returns (uint) {
        return contributions[x];
    }
}