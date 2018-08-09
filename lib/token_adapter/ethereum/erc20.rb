module TokenAdapter
  module Ethereum
    class Erc20 < Eth

      attr_accessor :token_contract_address

      def initialize(config)
        super(config)
      end

      def getbalance(account = nil)
        account ||= (config[:exchange_address] || TokenAdapter::Ethereum.exchange_address)

        coin = self.class.name.split('::').last.downcase
        tx = GarnetClient::Service.wallet_get_balance(coin,account)
        result = tx[0]['result']['value']
        result
      end

      # 用户提币
      def sendtoaddress(address, amount, nonce = nil)
        amount_in_wei = (amount * (10**token_decimals)).to_i
        coin = self.class.name.split('::').last.downcase

        tx = GarnetClient::Service.tx_transfer(coin,nonce, nil, address, amount_in_wei)
        rs = GarnetClient::Result.new(tx)

        raise TxHashError, 'txhash is nil' if rs.success?
        tx[0]['result']['tx_id']
      end

      def generate_rawtx_with_nonce(address, amount, nonce, id = nil)
        gas_limit = config[:transfer_gas_limit] || TokenAdapter::Ethereum.transfer_gas_limit
        gas_price = config[:transfer_gas_price] || TokenAdapter::Ethereum.transfer_gas_price
        data = build_data(address, amount)
        rawtx = generate_raw_transaction(from, nil, data, gas_limit, gas_price, token_contract_address, nonce)
        { method: 'eth_sendRawTransaction', params: [ rawtx ], id: id || 1 }
      end

      # 获取网关提币信息
      def get_garnet_transaction(txid)
        coin = self.class.name.split('::').last.downcase
        garnet_tx = GarnetClient::Service.tx_get_info(coin, txid)
        rs = GarnetClient::Result.new(tx)
        return nil unless rs.success?
        tx = {}
        tx['timereceived'] = garnet_tx[0]['result']['updatedAt'].to_i
        tx['from'] = garnet_tx[0]['result']['from']
        tx['tx_hash'] = garnet_tx[0]['result']['txHash']
        tx['details'] = [
            {
                'account' => 'payment',
                'category' => 'receive',
                'amount' => tx[0]['result']['value'].to_i,
                'address' => tx[0]['result']['to'],
                'gas' => tx[0]['result']['gas'].to_i,
                'gas_price' => tx[0]['result']['gasPrice'].to_i
            }
        ]
        tx
      end

      # 用于充值，严格判断
      def gettransaction(txid)
        tx = super(txid)
        return nil unless tx

        # 数量 和 地址
        data = tx['input'] || tx['raw']
        input = extract_input(data)
        from = '0x' + padding(tx['from'])
        to = '0x' + input[:params][0]
        value = '0x' + input[:params][1]

        # 看看这个交易实际有没有成功
        return nil unless has_transfer_event_log?(tx['receipt'], from, to, value)

        # 填充交易所需要的数据
        tx['details'] = [
            {
                'account' => 'payment',
                'category' => 'receive',
                'amount' => value.to_i(16) / 10.0**token_decimals,
                'address' => "0x#{input[:params][0][24 .. input[:params][0].length-1]}"
            }
        ]

        return tx
      end

      def build_data(address, amount)
        function_signature = 'a9059cbb' # Ethereum::Function.calc_id('transfer(address,uint256)') # a9059cbb
        amount_in_wei = (amount * (10**token_decimals)).to_i
        '0x' + function_signature + padding(address) + padding(dec_to_hex(amount_in_wei))
      end

      def transfer_token(private_key, token_address, token_decimals, amount, gas_limit, gas_price, to)
        data = build_data(to, amount)

        #生成签名交易
        raw_tx = generate_raw_transaction(private_key, nil, data, gas_limit, gas_price, token_address)
        eth_send_raw_transaction(raw_tx)
      end

    end
  end

end
