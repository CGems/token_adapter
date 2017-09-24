module TokenAdapter
  module Ethereum
    module Provider
      module Base
        def out_of_gas?(tx, receipt)
          tx['gas'] === receipt['gasUsed'] # out of gas，交易失败
        end

        # from to value 以16进制字符串表示, 64位
        def has_transfer_event_log?(receipt, from, to, value)
          topics = [
              '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
              from,
              to
          ]
          return has_event_log?(receipt, config[:token_contract_address], topics, value)
        end

        def has_event_log?(receipt, address, topics, data)
          logs = receipt['logs']
          return false unless logs

          logs.each do |log|
            return true if log_equal?(log, address, topics, data)
          end

          return false
        end

        def extract_input(data)
          method_id = data[0 .. 9]
          params = data[10 .. data.length-1].scan /[abcdef0-9]{64}/
          {method_id: method_id, params: params}
        end

        def log_equal?(log, address, topics, data)
          return false unless log['address']

          return false unless log['address'] == address.downcase

          return true if topics.length === 0

          return false unless (log['topics'] && log['topics'].length === topics.length)

          log['topics'].each_with_index do |topic, i|
            return false unless topic === topics[i]
          end

          return false unless log['data'] === data

          return true
        end

        # nil or rawtx
        def generate_raw_transaction(priv, value, data, gas_limit, gas_price, to = nil)
          key = ::Eth::Key.new priv: priv
          transaction_count = eth_get_transaction_count(key.address)
          return nil unless transaction_count >= 0

          args = {
              from: key.address,
              value: 0,
              data: '0x0',
              nonce: transaction_count,
              gas_limit: gas_limit,
              gas_price: gas_price
          }
          args[:value] = (value * 10**18).to_i if value
          args[:data] = data if data
          args[:to] = to if to
          tx = ::Eth::Tx.new(args)
          tx.sign key
          tx.hex
        end

        def wait_for_miner(txhash, timeout: 300.seconds, step: 5.seconds)
          start_time = Time.now
          loop do
            raise Timeout::Error if ((Time.now - start_time) > timeout)
            return true if mined?(txhash)
            sleep step
          end
        end

        def mined?(txhash)
          result = eth_get_transaction_by_hash(txhash)
          result['blockNumber'].present?
        end

        # tools
        def hex_wei_to_dec_eth(wei)
          hex_to_dec(wei)/10.0**18
        end

        def dec_eth_to_hex_wei(value)
          dec_wei = (value * 10**18).to_i
          dec_to_hex(dec_wei)
        end

        def dec_to_hex(value)
          '0x'+value.to_s(16)
        end

        def hex_to_dec(value)
          value.to_i(16)
        end

        def str_to_hex(s)
          '0x'+s.each_byte.map { |b| b.to_s(16) }.join
        end

        def padding(str)
          if str =~ /^0x[a-f0-9]*/
            str = str[2 .. str.length-1]
          end
          str.rjust(64, '0')
        end

        def without_0x(address)
          address[2 .. address.length-1]
        end

        def eth_address(str)
          str = str.to_s
          if str.size == 66
            new_addr = str[0,2] + str[26, str.size - 26]
          else
            new_addr = str
          end
          new_addr
        end
      end
    end

  end
end