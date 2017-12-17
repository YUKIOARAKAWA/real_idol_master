pragma solidity ^0.4.15;

contract Idol {

  uint256 public id;
  string public name;
  uint256 public max_issuance;

  function registerIdol(string _name, uint256 _max_issuance) {

  }

  function checkIdolExistence(uint256 _id) constant returns (bool) {
    return true;
  }
}
