module ChainAdapter
  module Eth
    module InfuraProvider
      include ChainAdapter::Eth::BaseProvider

      def init_provider(config)
        Infura.logger = ChainAdapter.logger
        Infura.token = config[:infura_token]
        Infura.chain = config[:chain]
      end

      def eth_get_balance(address)
        result = Infura.eth_get_balance(address: address)
        result.to_i(16) / 10**18.0
      end
  
      def eth_get_transaction_count(address)
        result = Infura.eth_get_transaction_count(address: address)
        result.to_i(16)
      end
  
      def eth_call(to, data)
        result = Infura.eth_call(object: {to: to, data: data})
        result.to_i(16)
      end

      def eth_send_raw_transaction(rawtx)
        Infura.eth_send_raw_transaction(data: rawtx)
      end

      def eth_get_transaction_by_hash(txhash)
        Infura.eth_get_transaction_by_hash(txhash: txhash)
      end
  
      def eth_get_transaction_receipt(txhash)
        Infura.eth_get_transaction_receipt(txhash: txhash)
      end
  
      def eth_block_number
        result = Infura.eth_block_number
        result.to_i(16)
      end
  
      def eth_get_block_by_number(block_number)
        Infura.eth_get_block_by_number(tag: block_number)
      end
    end
  end
end