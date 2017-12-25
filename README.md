# Geth実行手順

## Set up
※ リポジトリのPATHは各自の環境に合わせてください※
### 1. Gethのインストール    
  1. go-ethereumをgitリポジトリからクローンする  
  ```
  $ git clone https://github.com/ethereum/go-ethereum.git
  $ cd go-ethereum
  $ git checkout refs/tags/v1.5.5
  ```
  2. make gethでビルドする
  ```
  $ make geth
  ```
  3. Gethのバージョン確認
  ```
  $ ./build/bin/geth version
  Geth
  Version: 1.5.5-stable
  Git Commit: ff07d54843ea7ed9997c420d216b4c007f9c80c3
  Protocol Versions: [63 62]
  Network Id: 1
  Go Version: go1.8.3
  OS: darwin
  GOPATH=/Users/shikitakahashi/go
  GOROOT=/usr/local/Cellar/go/1.8.3/libexec
  ```
  4. Gethを/usr/local/binにコピーする
  ```
  $ sudo cp build/bin/geth /usr/local/bin/
  ```
  5. パスが通っていることを確認する
  ```
  $ which geth
  /usr/local/bin/geth
  ```

### 2. テストネットワークでGethを起動する
  1. データディレクトリを準備する
  ```
  $ mkdir ~/data_testnet
  $ cd data_testnet/
  $ pwd
  /home/eth/data_testnet
  ```
  2. Genesisファイルを作成する
  ```
  $ vi genesis.json
  {
    "nonce": "0x0000000000000042",
    "timestamp": "0x0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x0",
    "gasLimit": "0xffffffff",
    "difficulty": "0x4000",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x0000000000000000000000000000000000000000",
    "alloc": {}
    }
  ```
  3. Gethを初期化する
  ```
  $ geth --datadir /home/eth/data_testnet init /home/eth/data_testnet/genesis.json
  ```

  4. Gethを起動する
  ```
  geth --datadir /Users/user1/data_testnet init /Users/user1/data_testnet/genesis.json
  ```

  5. EOAを作成し、マイニングを開始する
  ※ pass0はEOAのパスワード
  ```
  > personal.newAccount("pass0")
  "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b"
  > eth.coinbase
  "0xd34da9604e5e9c2a9cc0aa481b6b24a72af3253b"
  > miner.start(1)
  true
  ```
  初回はDAG(Directed acyclic graph)の生成が行われるため、マイニングが行われるまでに若干時間がかかる。  
  マイニングが始まればハッシュレートが1以上の値となる。
  ```
  > eth.hashrate
  140956
  ```




### 3. Smart contract開発用のコンパイラをインストール
  1. 以下のコマンドを実行してSolidityのコンパイラをインストールする。
  ```
  $ brew update
  $ brew upgrade
  $ brew tap ethereum/ethereum
  $ brew install solidity
  $ brew linkapps solidity
  ```
  2. インストールされたことを確認する。
  ```
  $ solc --version
  solc, the solidity compiler commandline interface
  Version: 0.4.15+commit.8b45bddb.Darwin.appleclang
  ```
  3. solcのPATHを確認する。
  ```
  $ which solc
  /usr/local/bin/solc
  ```
  4. admin.setSolcコマンドでGethにsolcのパスをセットする。
  ```
  > admin.setSolc("/usr/bin/solc")
  ```
  正しく、セットされたことを確認する。
  ```
  > eth.getCompilers()
  ["Solidity"]
  ```

### 4. Smart Contractのデプロイ
以下の操作は2の4で起動したgethコンソール上で行う（>になってるところ）

1. デプロイするsourceを定義する。
```
source = 'pragma solidity ^0.4.15;contract IdolContract {  uint256 public id = 1;  address public developerAddress;  struct Idol {    string name;    uint256 issuance;  }  mapping (uint256 => Idol) idols;  mapping (bytes32 => uint256) IdolHashToOwner;  modifier onlyDeveloper() {      require(msg.sender == developerAddress);      _;  }  function setDeveloperAddress() {      developerAddress = msg.sender;  }  function setIdol(string _name, uint256 _issuance) public {    idols[id].name = _name;    idols[id].issuance = _issuance;    id += 1;  }  function getIdol(uint256 _id) constant returns (string, uint256) {    return (idols[_id].name, idols[_id].issuance);  }  function checkIdolExistence(uint256 _id) constant returns (bool) {    if (idols[_id].issuance != 0) {      return true;    }    return false;  }  function decreaseIssuance(uint256 _id, uint256 _userId) public returns (bytes32) {    uint256 _issuance = idols[_id].issuance;    bytes32 registeredId = registerIdolHashToOwner(_id, _issuance, _userId);    idols[_id].issuance -= 1;    return registeredId;  }  function registerIdolHashToOwner(uint256 _id, uint256 _issuance, uint256 _userId) internal returns (bytes32) {    bytes32 registeredId = keccak256(_id, _issuance);    IdolHashToOwner[registeredId] = _userId;    return registeredId;  }  function getMappingIdolHashToOnwer(bytes32 _idolKey) onlyDeveloper constant returns (uint256) {    uint256 ownerId = IdolHashToOwner[_idolKey];    return ownerId;  }  function removeIdol(uint256 _id) onlyDeveloper public {    require(_id <= id - 1);    delete idols[_id];    for (uint256 i = _id; i < id; i++) {        idols[i].name = idols[i + 1].name;        idols[i].issuance = idols[i + 1].issuance;    }    delete idols[id - 1];    id -= 1;  }}'
```

2. sourceをコンパイルする。

```
sourceCompiled = eth.compile.solidity(source)
```

3. sourceCompiledからABIを取得する。
sourceCompiled[]の''の中は2のコンパイルの応答の2行目の部分になる。

```
contractAbiDefinition = sourceCompiled['/var/folders/jx/sr81nn7j7ts95mfbxdzn1hd00000gn/T/geth-compile-solidity099927807:IdolContract'].info.abiDefinition
```

4. ABIからコントラクトオブジェクトを作成する。

```
sourceCompiledContract = eth.contract(contractAbiDefinition)
```

5. アカウントのロックを解除する。

```
personal.unlockAccount(eth.accounts[0], 'pass0', 1000000)
```

6. コントラクトをデプロイする。

```
contract = sourceCompiledContract.new({from: eth.accounts[0], data: sourceCompiled['/var/folders/jx/sr81nn7j7ts95mfbxdzn1hd00000gn/T/geth-compile-solidity099927807:IdolContract'].code, gas: '4700000'})
```

しばらくするとaddress部分に値が割り振られる。
（contract.addressで確認できる）

### 5. アプリケーションの設定
ethereum_api.rbの以下の定数の値を自分の環境に合わせる。

- ETHEREUM_ADDRESS：personal.newAccount("pass0")で作ったアカウントのaddress
- CONTRACT_ADDRESS：4で取得したcontract.address
