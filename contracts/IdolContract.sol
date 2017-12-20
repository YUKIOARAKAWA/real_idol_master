pragma solidity ^0.4.15;

contract IdolContract {

  uint256 public id = 1;

  address public developerAddress;

  struct Idol {
    string name;
    uint256 issuance;
  }

  mapping (uint256 => Idol) idols;
  // Idolのindexは一意だが、同じIdolに対する写真が複数あるため、Indexをそのままkeyにすることができない
  // そのため、keyとそのときのissuanceでハッシュ値を計算した値をmappingのkeyにする
  mapping (bytes32 => uint256) IdolHashToOwner;

  modifier onlyDeveloper() {
      require(msg.sender == developerAddress);
      _;
  }

  function setDeveloperAddress() {
      developerAddress = msg.sender;
  }

  function setIdol(string _name, uint256 _issuance) public {

    idols[id].name = _name;
    idols[id].issuance = _issuance;

    id += 1;
  }

  function getIdol(uint256 _id) constant returns (string, uint256) {
    return (idols[_id].name, idols[_id].issuance);
  }

  function checkIdolExistence(uint256 _id) constant returns (bool) {
    if (idols[_id].issuance != 0) {
      return true;
    }
    return false;
  }

  function decreaseIssuance(uint256 _id, uint256 _userId) public returns (bytes32) {
    uint256 _issuance = idols[_id].issuance;

    bytes32 registeredId = registerIdolHashToOwner(_id, _issuance, _userId);
    idols[_id].issuance -= 1;
    return registeredId;
  }

  function registerIdolHashToOwner(uint256 _id, uint256 _issuance, uint256 _userId) internal returns (bytes32){
    // idolのidとissuanceからhash値を計算する
    bytes32 registeredId = keccak256(_id, _issuance);
    IdolHashToOwner[registeredId] = _userId;
    return registeredId;
  }

  // @dev
  // ToDo: remove onlyDeveloper and add onlyOnwer
  function getMappingIdolHashToOnwer(bytes32 _idolKey) onlyDeveloper constant returns (uint256) {
    uint256 ownerId = IdolHashToOwner[_idolKey];
    return ownerId;
  }
}
