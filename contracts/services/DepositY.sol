pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../interfaces/y/ICurveFi_DepositY.sol";
import "hardhat/console.sol";


contract DepositY is Initializable, Context, Ownable{

    using SafeMath for uint256;

    uint256 public constant N_COINS = 4;
    address public curveFi_Deposit;
    address public curveFi_Swap;
    address public coin;
    address[N_COINS] __coins;
    address[N_COINS] __underlying;

    // function initialize() external initializer {
    //     Ownable.initialize(_msgSender());
    // }

    function setup(address _depositContract) external {
        require(_depositContract != address(0), "Incorrect deposit contract address");
        curveFi_Deposit = _depositContract;
        curveFi_Swap = ICurveFi_DepositY(curveFi_Deposit).curve();
        coin = ICurveFi_DepositY(curveFi_Deposit).coins(int128(0));
        // __underlying = ICurveFi_DepositY(curveFi_Deposit).underlying_coins();
    }
}