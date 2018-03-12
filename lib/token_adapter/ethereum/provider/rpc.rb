module TokenAdapter
  module Ethereum
    module Provider
      module Rpc
        include TokenAdapter::JsonRpc

        def init_provider(config)
          @rpc = config[:rpc]
        end

        def eth_get_balance(address)
          fetch method: 'eth_getBalance', params: [address, 'latest']
        end

        def eth_get_transaction_count(address, tag = 'latest')
          fetch method: 'eth_getTransactionCount', params: [address, tag]
        end

        def eth_call(to, data)
          fetch method: 'eth_call', params: [{to: to, data: data}, 'latest']
        end

        def personal_unlock_account(address, passphrase)
          fetch method: 'personal_unlockAccount', params: [address, passphrase]
        end

        def eth_send_raw_transaction(rawtx)
          fetch method: 'eth_sendRawTransaction', params: [rawtx]
        end

        def eth_send_transaction(from, to, gas, gas_price, value, data, nonce)
          params = {}
          params['from'] = from if from
          params['to'] = to if to
          params['gas'] = gas if gas
          params['gasPrice'] = gas_price if gas_price
          params['value'] = value if value
          params['data'] = data if data
          params['nonce'] = nonce if nonce

          fetch method: 'eth_sendTransaction', params: [params]
        end

        def eth_estimate_gas(from, to, gas, gas_price, value, data, nonce)
          params = {}
          params['from'] = from if from
          params['to'] = to if to
          params['gas'] = gas if gas
          params['gasPrice'] = gas_price if gas_price
          params['value'] = value if value
          params['data'] = data if data
          params['nonce'] = nonce if nonce

          fetch method: 'eth_estimateGas', params: [params]
        end

        def eth_gas_price
          fetch method: 'eth_gasPrice', params: []
        end

        def eth_get_transaction_by_hash(txhash)
          fetch method: 'eth_getTransactionByHash', params: [txhash]
        end

        def eth_get_transaction_receipt(txhash)
          fetch method: 'eth_getTransactionReceipt', params: [txhash]
        end

        def eth_block_number
          fetch method: 'eth_blockNumber', params: []
        end

        def eth_get_block_by_number(block_number)
          fetch method: 'eth_getBlockByNumber', params: [block_number, true]
        end


      end
    end
  end
end

