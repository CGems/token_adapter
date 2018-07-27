module TokenAdapter
  module Bilur
    class Erc40 < Erc20

      # 用户提币
      def sendtoaddress(address, amount, nonce = nil)
        # 生成raw transaction
        data = build_data(address, amount)
        gas_limit = config[:transfer_gas_limit] || TokenAdapter::Ethereum.transfer_gas_limit 
        gas_price = config[:transfer_gas_price] || TokenAdapter::Ethereum.transfer_gas_price
        to = token_contract_address

        # 计算转币需要支付的基础货币bpx
        fee = get_transfer_fee(amount)

        txhash = send_transaction(from: from, value: fee, data: data, gas_limit: gas_limit, gas_price: gas_price, to: to)
        raise TxHashError, 'txhash is nil' unless txhash
        txhash
      end

      def get_transfer_fee(token_amount)
        fee_rate = get_fee_rate
        fee_max = get_fee_max / BigDecimal(10**18)
        fee_min = get_fee_min / BigDecimal(10**18)
        fee = BigDecimal(token_amount) / BigDecimal(fee_rate)
        if fee < fee_min
          return fee_min
        end
        if fee >= fee_max
          return fee_max
        end
        return fee
      end

      #
      def get_fee_rate
        function_signature = '0x978bbdb9'
        result = eth_call(token_contract_address, function_signature)
        BigDecimal(result.to_i(16))
      end

      # fee最小值
      def get_fee_min
        function_signature = '0x24ec7590'
        result = eth_call(token_contract_address, function_signature)
        BigDecimal(result.to_i(16))
      end

      # fee最大值
      def get_fee_max
        function_signature = '0x01f59d16'
        result = eth_call(token_contract_address, function_signature)
        BigDecimal(result.to_i(16))
      end

    end
  end

end
