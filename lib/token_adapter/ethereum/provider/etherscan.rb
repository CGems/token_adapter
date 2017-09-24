module TokenAdapter
  module Ethereum
    module Provider
      module Etherscan
        include TokenAdapter::Ethereum::Provider::Base
        using PatternMatch

        def init_provider(config)
          Etherscan.logger = TokenAdapter.logger
          Etherscan.api_key = config[:etherscan_api_key]
          Etherscan.chain = config[:chain]
        end

        def eth_get_balance(address)
          ret = Etherscan::Account.balance(address, 'latest')
          match(ret) do
            with(_[:error, e]) { nil }
            with(_[:ok, result]) { result.to_f / 10**18 }
          end
        end

        # -1: error
        def eth_get_transaction_count(address)
          ret = Etherscan::Proxy.eth_get_transaction_count(address, 'latest')
          match(ret) do
            with(_[:error, message]) { -1 }
            with(_[:ok, result]) { result.to_i(16) }
          end
        end

        # -1 or +
        def eth_call(to, data)
          ret = Etherscan::Proxy.eth_call(to, data, 'latest')
          match(ret) do
            with(_[:error, message]) { -1 }
            with(_[:ok, result]) { result.to_i(16) }
          end
        end

        # nil or txhash
        def eth_send_raw_transaction(rawtx)
          ret = Etherscan::Proxy.eth_send_raw_transaction(rawtx)
          match(ret) do
            with(_[:error, message]) { nil }
            with(_[:ok, result]) { result }
          end
        end

        # nil or tx
        def eth_get_transaction_by_hash(txhash)
          ret = Etherscan::Proxy.eth_get_transaction_by_hash(txhash)
          match(ret) do
            with(_[:error, message]) { nil }
            with(_[:ok, result]) { result }
          end
        end

        # nil or txreceipt
        def eth_get_transaction_receipt(txhash)
          ret = Etherscan::Proxy.eth_get_transaction_receipt(txhash)
          match(ret) do
            with(_[:error, message]) { nil }
            with(_[:ok, result]) { result }
          end
        end

        def eth_block_number
          ret = Etherscan::Proxy.eth_block_number
          match(ret) do
            with(_[:error, message]) { nil }
            with(_[:ok, result]) { result.to_i(16) }
          end
        end

        def eth_get_block_by_number(block_number)
          ret = Etherscan::Proxy.eth_get_block_by_number(block_number, 'true')
          match(ret) do
            with(_[:error, message]) { nil }
            with(_[:ok, result]) { result }
          end
        end
      end
    end
  end
end