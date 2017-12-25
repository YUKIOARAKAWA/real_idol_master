class EthereumAPI
  require "json"

  # この設定は自分の環境に合わせる
  ETHEREUM_ADDRESS = "/Users/user1/data_testnet/geth.ipc"
  ETHEREUM_IDOL_CONTRACT = "#{Dir.pwd}/contracts/IdolContract.sol"
  CONTRACT_ADDRESS = "0x6db6c68c05c0b7d228ba5322d1beab5c2ac6924b"

  SUPPLIER_ADDRESS = "0x030ad335eb3154c720c1da0be92c295fc1fbe0ae"
  SUPPLIER_PASSWORD = "pass0"

  IDOL_ABI = '[{  "constant": true,  "inputs": [{  "name": "_id",  "type": "uint256"}  ],  "name": "getIdol",  "outputs": [{  "name": "",  "type": "string"},{  "name": "",  "type": "uint256"}  ],  "payable": false,  "stateMutability": "view",  "type": "function"},{  "constant": false,  "inputs": [{  "name": "_id",  "type": "uint256"},{  "name": "_userId",  "type": "uint256"}  ],  "name": "decreaseIssuance",  "outputs": [{  "name": "",  "type": "bytes32"}  ],  "payable": false,  "stateMutability": "nonpayable",  "type": "function"},{  "constant": true,  "inputs": [{  "name": "_idolKey",  "type": "bytes32"}  ],  "name": "getMappingIdolHashToOnwer",  "outputs": [{  "name": "",  "type": "uint256"}  ],  "payable": false,  "stateMutability": "view",  "type": "function"},{  "constant": true,  "inputs": [{  "name": "_id",  "type": "uint256"}  ],  "name": "checkIdolExistence",  "outputs": [{  "name": "",  "type": "bool"}  ],  "payable": false,  "stateMutability": "view",  "type": "function"},{  "constant": true,  "inputs": [],  "name": "id",  "outputs": [{  "name": "",  "type": "uint256"}  ],  "payable": false,  "stateMutability": "view",  "type": "function"},{  "constant": false,  "inputs": [{  "name": "_name",  "type": "string"},{  "name": "_issuance",  "type": "uint256"}  ],  "name": "setIdol",  "outputs": [],  "payable": false,  "stateMutability": "nonpayable",  "type": "function"},{  "constant": true,  "inputs": [],  "name": "developerAddress",  "outputs": [{  "name": "",  "type": "address"}  ],  "payable": false,  "stateMutability": "view",  "type": "function"},{  "constant": false,  "inputs": [],  "name": "setDeveloperAddress",  "outputs": [],  "payable": false,  "stateMutability": "nonpayable",  "type": "function"}  ]'

  # とりま、clientのアカウントはaccounts[0]で固定
  def set_client
    @client = Ethereum::IpcClient.new(ETHEREUM_ADDRESS)
    @client.personal_unlock_account(SUPPLIER_ADDRESS, SUPPLIER_PASSWORD)
  end

  def check_idol_issuance(idol_id, user)

    @client = Ethereum::IpcClient.new(ETHEREUM_ADDRESS)
    @client.personal_unlock_account(SUPPLIER_ADDRESS, SUPPLIER_PASSWORD)
    puts @client.eth_get_balance("0x030ad335eb3154c720c1da0be92c295fc1fbe0ae")
    begin
      @contract = Ethereum::Contract.create(file: ETHEREUM_IDOL_CONTRACT, client: @client, address: CONTRACT_ADDRESS, abi: IDOL_ABI)
      binding.pry
      result = @contract.call.check_idol_existence(idol_id)
    rescue => e
      puts "Exception handling"
      puts e.message
    end

    if result == true
      registered_id = @contract.transact_and_wait.decrease_issuance(idol_id, user.id)
      return result
    else
      return result
    end
  end
end
