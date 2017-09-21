module ChainAdapter
  class Eth < Base
    include ChainAdapter::EthHelper
    using PatternMatch

    def initialize(config)
      super(config)
      Etherscan.api_key = config[:etherscan_api_key]
      Etherscan.chain = config[:chain]
    end

    # 获取交易所的地址上币
    def getbalance
      ret = Etherscan::Account.balance(config[:exchange_address], 'latest')
      match(ret) do
        with(_[:error, e]) { nil }
        with(_[:ok, result]) { result.to_f / 10**18 }
      end
    end

    def getnewaddress(account, passphase)
      priv = config[:exchange_address_priv]
      address_contract_address = config[:contract_address]
      gas_limit = config[:gas_limit]
      gas_price = config[:gas_price]

      # 生成raw tx
      data = '0xa9b1d507' # Ethereum::Function.calc_id('makeWallet()')
      to = address_contract_address
      rawtx = generate_raw_transaction(priv, nil, data, gas_limit, gas_price, to)
      return nil unless rawtx

      # 执行raw tx
      txhash = send_raw_transaction(rawtx)
      return nil unless txhash

      # 查看合约执行是否正常
      # status = transaction_getstatus(txhash)
      # return nil unless status == '0'

      # 等待上链
      wait_for_miner(txhash)

      # 先从internal tx list里找
      # txlistinternal = txlistinternal(txhash)
      # return txlistinternal.first['contractAddress'] if txlistinternal.length > 0

      # 从回执的logs里找
      receipt = eth_get_transaction_receipt(txhash)
      return eth_address(receipt['logs'][0]['data'])
    end

    # 用户提币
    def sendtoaddress(address, amount)
      rawtx = generate_raw_transaction(config[:exchange_address_priv],
                                       amount,
                                       nil,
                                       config[:gas_limit],
                                       config[:gas_price],
                                       address)
      return nil unless rawtx

      send_raw_transaction(rawtx)
    end

    # 用于充值，自己添加的属性，数字是10进制的（原始的是字符串形式的16进制）
    def gettransaction(txid)
      tx = get_transaction_by_hash(txid)
      return nil unless (tx && tx['blockNumber']) # 未上链的直接返回nil

      # 确认数
      number = block_number
      return nil unless number
      current_block_number = hex_to_dec(number) # 当前的高度
      transaction_block_number = hex_to_dec(tx['blockNumber'])
      tx['confirmations'] = current_block_number - transaction_block_number

      # 上链时间
      block = get_block_by_number(tx['blockNumber'])
      if block
        tx['timereceived'] = hex_to_dec(block['timestamp'])
      else
        tx['timereceived'] = Time.now.to_i
      end

      # 数量 和 地址
      tx['details'] = [
          {
              'account' => 'payment',
              'category' => 'receive',
              'amount' => hex_wei_to_dec_eth(tx['value']),
              'address' => tx['to']
          }
      ]

      return tx
    end


  end
end
