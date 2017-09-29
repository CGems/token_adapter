module TokenAdapter
  module Ethereum
    class Erc20 < Eth

      def initialize(config)
        super(config)
      end

      def getbalance
        function_signature = '70a08231' # Ethereum::Function.calc_id('balanceOf(address)') # 70a08231
        data = '0x' + function_signature + padding(config[:exchange_address])
        to = config[:token_contract_address]

        eth_call(to, data) / 10**config[:token_decimals]
      end

      # 用户提币
      def sendtoaddress(address, amount)
        # 生成raw transaction
        function_signature = 'a9059cbb' # Ethereum::Function.calc_id('transfer(address,uint256)') # a9059cbb
        amount_in_wei = (amount * (10**config[:token_decimals])).to_i
        data = '0x' + function_signature + padding(address) + padding(dec_to_hex(amount_in_wei))
        gas_limit = config[:transfer_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:transfer_gas_price] || config[:gas_price] || 20_000_000_000
        to = config[:token_contract_address]

        txhash = send_transaction(from: from, data: data, gas_limit: gas_limit, gas_price: gas_price, to: to)
        raise TxHashError, 'txhash is nil' unless txhash
        txhash
      end

      # 用于充值，严格判断
      def gettransaction(txid)
        tx = super(txid)
        return nil unless tx

        # 数量 和 地址
        data = tx['input'] || tx['raw']
        input = extract_input(data)
        from = padding(tx['from'])
        to = '0x' + input[:params][0]
        value = '0x' + input[:params][1]

        # 看看这个交易实际有没有成功
        return nil unless has_transfer_event_log?(tx['receipt'], from, to, value)

        # 填充交易所需要的数据
        tx['details'] = [
          {
            'account' => 'payment',
            'category' => 'receive',
            'amount' => value.to_i(16) / 10**config[:token_decimals],
            'address' => "0x#{input[:params][0][24 .. input[:params][0].length-1]}"
          }
        ]

        return tx
      end

      def wallet_collect(wallet_address, token_address, amount)
        function_signature = '6ea056a9' # Ethereum::Function.calc_id('sweep(address,uint256)')
        amount_in_wei = (amount*(10**config[:token_decimals])).to_i
        data = "0x#{function_signature}#{padding(token_address)}#{padding(dec_to_hex(amount_in_wei))}"
        gas_limit = config[:collect_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:collect_gas_price] || config[:gas_price] || 20_000_000_000

        txhash = send_transaction(from: from, data: data, gas_limit: gas_limit, gas_price: gas_price, to: wallet_address)
        raise TxHashError, 'txhash is nil' unless txhash

        raise TxHashError, 'txhash is zero' if hex_to_dec(txhash) == 0
        txhash
      end

    end
  end

end
