module ChainAdapter
  class Erc20 < Eth

    def initialize(config)
      super(config)
    end

    def getbalance
      function_signature = '70a08231' # Ethereum::Function.calc_id('balanceOf(address)') # 70a08231
      data = '0x' + function_signature + padding(config[:exchange_address])
      to = config[:token_contract_address]

      call(to, data) / 10**config[:token_decimals]
    end

    # 用户提币
    def sendtoaddress(address, amount)
      # 生成raw transaction
      function_signature = 'a9059cbb' # Ethereum::Function.calc_id('transfer(address,uint256)') # a9059cbb
      amount_in_wei = (amount*(10**config[:token_decimals])).to_i
      data = '0x' + function_signature + padding(address) + padding(dec_to_hex(amount_in_wei))
      rawtx = generate_raw_transaction(config[:exchange_address_priv],
                                       nil,
                                       data,
                                       config[:gas_limit],
                                       config[:gas_price],
                                       config[:token_contract_address])
      return nil unless rawtx

      send_raw_transaction(rawtx)
    end

    # 用于充值，严格判断
    def gettransaction(txid)
      tx = super(txid)
      return nil unless tx

      # 看看这个交易实际有没有成功
      return nil unless transfer_succeeded?(txid)

      # 数量 和 地址
      data = tx['input'] || tx['raw']
      matched = /(0{24}[abcdef0-9]{40})(0{24}[abcdef0-9]{40})/.match(data)
      return nil unless matched
      tx['details'] = [
          {
              'account' => 'payment',
              'category' => 'receive',
              'amount' => matched[2].to_i(16) / 10**config[:token_decimals],
              'address' => "0x#{matched[1][24 .. matched[1].length-1]}"
          }
      ]

      return tx
    end

    def transfer_succeeded?(txhash)
      receipt = eth_get_transaction_receipt(txhash)
      return false if hex_to_dec(receipt['gasUsed']) === config[:gas_limit] # out of gas，交易失败
      return has_transfer_event_log?(receipt)
    end

    def has_transfer_event_log?(receipt)
      receipt['logs'].each do |log|
        if log['address'] && log['address'] == config[:token_contract_address].downcase && log['topics'][0] == '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'
          return true
        end
      end
      return false
    end

  end
end
