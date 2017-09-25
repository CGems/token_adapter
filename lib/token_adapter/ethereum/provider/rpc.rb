module TokenAdapter
  module Ethereum
    module Provider
      module Rpc
        include TokenAdapter::Ethereum::Provider::Base
        include TokenAdapter::JsonRpc

        def init_provider(config)
          @rpc = config[:rpc]
        end

        def eth_get_balance(address)
          result = fetch method: 'eth_getBalance', params: [address, 'latest']
          result.to_i(16) / 10**18.0
        end

        def eth_get_transaction_count(address)
          result = fetch method: 'eth_getTransactionCount', params: [address, 'latest']
          result.to_i(16)
        end

        def eth_call(to, data)
          result = fetch method: 'eth_call', params: [{to: to, data: data}, 'latest']
          result.to_i(16)
        end

        def eth_send_raw_transaction(rawtx)
          fetch method: 'eth_sendRawTransaction', params: [rawtx]
        end

        def eth_get_transaction_by_hash(txhash)
          fetch method: 'eth_getTransactionByHash', params: [txhash]
        end

        def eth_get_transaction_receipt(txhash)
          fetch method: 'eth_getTransactionByReceipt', params: [txhash]
        end

        def eth_block_number
          result = fetch method: 'eth_blockBumber', params: []
          result.to_i(16)
        end

        def eth_get_block_by_number(block_number)
          fetch method: 'eth_getBlockByNumber', params: [block_number, true]
        end


      end
    end
  end
end
