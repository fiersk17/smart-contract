/**
 * This smart contract code is Copyright 2017 Cryptf.io Ltd. For more information see https://cryptf.io
 *
 * Licensed under the Apache License, version 2.0
 */

pragma solidity ^0.4.15;

import "./PricingStrategy.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * Progressive crowdsale pricing - investors get extra tokens depending on invested sum.
 */
contract ProgressivePricing is PricingStrategy {

  using SafeMath for uint;

  /* How many weis one token costs */
  uint public oneTokenInWei;

  // bonus array tuples (from_sum_ether, bonus_percent)
  uint[] bonuses;

  function ProgressivePricing(uint _oneTokenInWei, uint[] _bonuses) public{
    require(_oneTokenInWei > 0);
    require(_bonuses.length > 1);

    bonuses=_bonuses;
    oneTokenInWei = _oneTokenInWei;
  }

  function getBonus(uint value) public constant returns (uint) {
    uint bonus=0;
    for (uint i=bonuses.length-2;i>=0;i-=2)
    {
      if (value>=bonuses[i]) {
        bonus=bonuses[i+1];
        break;
      }
    }
    return bonus;
  }

  /**
   * Calculate the current price for buy in amount.
   *
   */
  function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
    uint multiplier = 10 ** decimals;

    uint bonus=getBonus(value);

    return value.mul(multiplier).mul(100+bonus).div(100).div(oneTokenInWei);
  }

}
