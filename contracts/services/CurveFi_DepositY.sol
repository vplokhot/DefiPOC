pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "../interfaces/y/ICurveFi_DepositY.sol";
import "../interfaces/y/IYERC20.sol";
import "../interfaces/y/ICurveFi_SwapY.sol";


contract CurveFi_DepositY is ICurveFi_DepositY, Initializable, Context {

    using SafeMath for uint256;
    using SafeMath for int256;
    using SafeERC20 for IERC20;

    uint256 public constant N_COINS = 4;

    //Curve.Fi Swap address
    address public __curve;
    //Curve.Fi LP token
    address public __token;
    address[N_COINS] __coins;
    address[N_COINS] __underlying;

    function initialize(address[N_COINS] memory _coins, address[N_COINS] memory _underlying_coins, address _curve, address _token) public initializer {
        __curve = _curve;
        __token = _token;
        for (uint256 i=0; i < N_COINS; i++){
            __coins[i] = _coins[i];
            __underlying[i] = _underlying_coins[i];
        }
    }

    function add_liquidity (uint256[N_COINS] memory uamounts, uint256 min_mint_amount) public override{
        uint256[N_COINS] memory amounts = [uint256(0), uint256(0), uint256(0), uint256(0)];

        for (uint256 i = 0; i < uamounts.length; i++) {
            if (uamounts[i] == 0) continue;

            IERC20(__underlying[i]).safeTransferFrom(_msgSender(), address(this), uamounts[i]);

            //Mint if needed
            IERC20(__underlying[i]).approve(__coins[i], uamounts[i]);
            IYERC20(__coins[i]).deposit(uamounts[i]);
            
            amounts[i] = IYERC20(__coins[i]).balanceOf(address(this));
            IERC20(__coins[i]).approve(__curve, amounts[i]);
        }
        ICurveFi_SwapY(__curve).add_liquidity(amounts, min_mint_amount);

        uint256 tokens = IERC20(__token).balanceOf(address(this));
        IERC20(__token).safeTransfer(_msgSender(), tokens);
    }
    
    function remove_liquidity (uint256 _amount, uint256[N_COINS] memory min_uamounts) public override{
        IERC20(__token).safeTransferFrom(_msgSender(), address(this), _amount);
        ICurveFi_SwapY(__curve).remove_liquidity(_amount, [uint256(0), uint256(0), uint256(0), uint256(0)]);
        _send_all(_msgSender(), min_uamounts);
    }

    function remove_liquidity_imbalance(uint256[N_COINS] memory uamounts, uint256 max_burn_amount) public override{
        uint256[N_COINS] memory amounts = [uint256(0), uint256(0), uint256(0), uint256(0)];

        for (uint256 i = 0; i < uamounts.length; i++) {
            if (uamounts[i] > 0) {
                uint256 rate = IYERC20(__coins[i]).getPricePerFullShare();
                amounts[i] = uamounts[i].mul(1e18).div(rate);
            }
        }

        //Transfrer max tokens in
        uint256 _tokens = IERC20(__token).balanceOf(_msgSender());
        if (_tokens > max_burn_amount) _tokens = max_burn_amount;

        IERC20(__token).safeTransferFrom(_msgSender(), address(this), _tokens);

        IERC20(__token).approve(__curve, _tokens);
        ICurveFi_SwapY(__curve).remove_liquidity_imbalance(amounts, max_burn_amount);

        //Transfer unused tokens back
        _tokens = IERC20(__token).balanceOf(address(this));
        IERC20(__token).safeTransfer(_msgSender(), _tokens);

        //Unwrap and transfer all the coins we've got
        _send_all(_msgSender(), [uint256(0), uint256(0), uint256(0), uint256(0)]);
    }

    function coins(int128 i) public view override returns (address){
               return __coins[uint256(int256(i))];
    }

    function underlying_coins(int128 i) public view override returns (address){
        return __underlying[uint256(int256(i))];
    }

    function underlying_coins() public view override returns (address[N_COINS] memory){
        return __underlying;
    }

    function curve() public view override returns (address){
        return __curve;
    }

    function token() public view override returns (address) {
        return __token;
    }

    function _send_all(address _addr, uint256[N_COINS] memory min_uamounts) internal {
        for (uint256 i = 0; i < N_COINS; i++) {
            address _coin = __coins[i];
            uint256 _balance = IYERC20(_coin).balanceOf(address(this));

            if (_balance == 0) { //Do nothing for 0 coins
                continue;
            }

            IYERC20(_coin).withdraw(_balance);

            address _ucoin = __underlying[i];
            uint256 _uamount = IERC20(_ucoin).balanceOf(address(this));
            require(_uamount >= min_uamounts[i], "Not enough coins withdrawn in Deposit");
            IERC20(_ucoin).safeTransfer(_addr, _uamount);
        }        
    }


}