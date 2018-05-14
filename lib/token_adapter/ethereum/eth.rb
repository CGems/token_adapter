module TokenAdapter
  module Ethereum
    class PendingTimeoutError < StandardError; end
    class TxHashError < StandardError; end

    class Eth < TokenAdapter::Base
      include Provider::Rpc

      attr_accessor :token_decimals

      def initialize(config)
        super(config)
        init_provider(TokenAdapter::Ethereum.rpc_endpoint || config[:rpc])
        token_decimals = 18
      end
  
      # 获取交易所的地址上币
      def getbalance(account = nil)
        account ||= (config[:exchange_address] || TokenAdapter::Ethereum.exchange_address)
        get_balance(account)
      end
  
      def getnewaddress(index, passphrase)
        xpub = TokenAdapter::Ethereum.xpub || config[:xpub]
        wallet = Bip44::Wallet.from_xpub(xpub)
        wallet.get_ethereum_address("M/#{index}")
      end

      # 用户提币
      def sendtoaddress(address, amount, nonce = nil)
        gas_limit = config[:transfer_gas_limit] || TokenAdapter::Ethereum.transfer_gas_limit
        gas_price = config[:transfer_gas_price] || TokenAdapter::Ethereum.transfer_gas_price

        txhash = send_transaction(from: from, value: amount, gas_limit: gas_limit, gas_price: gas_price, to: address, nonce: nonce)
        raise TxHashError, 'txhash is nil' unless txhash
        txhash
      end

      # 用于充值，自己添加的属性，数字是10进制的（原始的是字符串形式的16进制）
      # 严格判断
      def gettransaction(txid)
        tx = eth_get_transaction_by_hash(txid)
        return nil unless (tx && tx['blockNumber']) # 未上链的直接返回nil，有没有可能之后又上链了？

        receipt = eth_get_transaction_receipt(tx['hash'])
        return nil unless receipt
        raise TransactionError, 'Transaction Fail' if (receipt['status'] && receipt['status'] == '0x0')
        # raise TransactionError, 'out of gas' if out_of_gas?(tx, receipt)

        # 把回执也作为tx的一部分返回
        tx['receipt'] = receipt

        # 确认数
        current_block_number = eth_block_number.to_i(16) # 当前的高度
        return nil unless current_block_number
        transaction_block_number = hex_to_dec(tx['blockNumber'])
        tx['confirmations'] = current_block_number - transaction_block_number

        # 上链时间
        block = eth_get_block_by_number(tx['blockNumber'])
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

      def validateaddress(address)
        {isvalid: true, ismine: false}
      end

      def settxfee(fee)
        # do nothing
      end

      def wallet_collect(wallet_address, token_address, amount)
        function_signature = '6ea056a9' # Ethereum::Function.calc_id('sweep(address,uint256)')
        amount_in_wei = (amount*(10**token_decimals)).to_i
        if token_address.nil?
          data = "0x#{function_signature}0x#{'0'*64}#{padding(dec_to_hex(amount_in_wei))}"
        else
          data = "0x#{function_signature}#{padding(token_address)}#{padding(dec_to_hex(amount_in_wei))}"
        end

        gas_limit = config[:collect_gas_limit] || TokenAdapter::Ethereum.collect_gas_limit
        gas_price = config[:collect_gas_price] || TokenAdapter::Ethereum.collect_gas_price

        txhash = send_transaction(from: from, data: data, gas_limit: gas_limit, gas_price: gas_price, to: wallet_address)
        raise TxHashError, 'txhash is nil' unless txhash

        raise TxHashError, 'txhash is zero' if hex_to_dec(txhash) == 0
        txhash
      end

      def get_balance(address)
        result = eth_get_balance(address)
        result.to_i(16) / 10**18.0
      end

      def get_total_balance(addresses)
        addresses.reduce(0) do |sum, address|
          sum + get_balance(address)
        end
      end

      # api.generate_raw_transaction("xxxx", 0, "0x6ea056a900000000000000000000000094d9eba82c8d45f53d19ac3c40163492ef83b38400000000000000000000000000000000000000000000000ae56f730e6d840000", 200000, 41000000000, "0x7ce6e0a649b3c25691e41ee39cded68d916a5d41", 62948)
      # nil or rawtx
      def generate_raw_transaction(priv, value, data, gas_limit, gas_price, to = nil, nonce = nil)

        key = ::Eth::Key.new priv: priv
        address = key.address

        gas_price_in_dec = gas_price.nil? ? eth_gas_price.to_i(16) : gas_price

        gas_price_in_dec = 5_000_000_000 if gas_price_in_dec < 5_000_000_000

        nonce = nonce.nil? ? eth_get_transaction_count(address, 'pending').to_i(16) : nonce

        args = {
          from: address,
          value: 0,
          data: '0x0',
          nonce: nonce,
          gas_limit: gas_limit,
          gas_price: gas_price_in_dec
        }
        args[:value] = (value * 10**18).to_i if value
        args[:data] = data if data
        args[:to] = to if to
        tx = ::Eth::Tx.new(args)
        tx.sign key
        tx.hex
      end

      private

      def from
        exchange_address_priv = config[:exchange_address_priv] || TokenAdapter::Ethereum.exchange_address_priv
        exchange_address = config[:exchange_address] || TokenAdapter::Ethereum.exchange_address
        exchange_address_passphrase = config[:exchange_address_passphrase] || TokenAdapter::Ethereum.exchange_address_passphrase
        if exchange_address_priv
          from = exchange_address_priv
        else
          from = {address: exchange_address, passphrase: exchange_address_passphrase}
        end
        from
      end

      def out_of_gas?(tx, receipt)
        tx['gas'] === receipt['gasUsed'] # out of gas，交易失败
      end

      # from to value 以16进制字符串表示, 64位
      def has_transfer_event_log?(receipt, from, to, data)
        topics = [
            '0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef',
            from,
            to
        ]
        return has_event_log?(receipt, token_contract_address, topics, data)
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

        return false unless log['topics'].length == topics.length

        log['topics'].each_with_index do |log_topic, i|
          return false unless log_topic == topics[i]
        end

        return false unless log['data'] == data

        true
      end

      def no_pending?(address)
        no_pending = false
        10.times do
          transaction_count = eth_get_transaction_count(address).to_i(16)
          pending_transaction_count = eth_get_transaction_count(address, 'pending').to_i(16)
          if transaction_count === pending_transaction_count
            no_pending = true
            break
          end
          sleep 6
        end

        return no_pending
      end

      def send_transaction(from: nil, value: nil, data: nil, gas_limit: nil, gas_price: nil, to: nil, nonce: nil)
        if from.is_a? String
          send_transaction_to_external(from, value, data, gas_limit, gas_price, to, nonce)
        else
          send_transaction_to_internal(from[:address], from[:passphrase], value, data, gas_limit, gas_price, to)
        end

      end

      def send_transaction_to_external(priv, value, data, gas_limit, gas_price, to = nil, nonce = nil)
        rawtx = generate_raw_transaction(priv, value, data, gas_limit, gas_price, to, nonce)
        txhash = eth_send_raw_transaction(rawtx) if rawtx
        return txhash
      end

      def send_transaction_to_internal(from, passphrase, value, data, gas_limit, gas_price, to = nil)
        personal_unlock_account(from, passphrase)
        if value
          value_in_wei = (value * (10**token_decimals)).to_i
          v = dec_to_hex(value_in_wei)
        else
          v = nil
        end

        gas_price_in_dec = gas_price.nil? ? eth_gas_price.to_i(16) : gas_price
        gas_price_in_dec = 5_000_000_000 if gas_price_in_dec < 5_000_000_000
        gas_price_in_hex = dec_to_hex(gas_price_in_dec)

        eth_send_transaction(
            (from.nil? ? nil : from),
            (to.nil? ? nil : to),
            dec_to_hex(gas_limit),
            gas_price_in_hex,
            v,
            (data.nil? ? nil : data),
            nil
        )
      end

      def wait_for_miner(txhash, timeout: 1200, step: 5)
        start_time = Time.now
        loop do
          raise Timeout::Error if ((Time.now - start_time) > timeout)
          return true if mined?(txhash)
          sleep step
        end
      end

      def mined?(txhash)
        result = eth_get_transaction_by_hash(txhash)
        result and (not result['blockNumber'].nil?)
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
