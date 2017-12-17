pragma solidity ^0.4.15;

contract IdolContract {

  uint256 public id;

  struct Idol {
    string name;
    uint256 issuance;
  }

  mapping (uint256 => Idol) idols;

  function setIdol(string _name, uint256 _issuance) public {

    idols[id].name = _name;
    idols[id].issuance = _issuance;

    id += 1;
  }

  function getIdol(uint256 _id) constant returns (string, uint256) {
    return (idols[_id].name, idols[_id].issuance);
  }

  function checkIdolExistence(uint256 _id) constant returns (bool) {
    for (uint i = 0; i <= id - 1; i++) {
      if (idols[_id].issuance != 0) {
        return true;
      }
    }
    return false;
  }
}
