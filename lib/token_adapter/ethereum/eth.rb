module TokenAdapter
  module Ethereum
    class PendingTimeoutError < StandardError; end
    class TxHashError < StandardError; end

    class << self
      attr_accessor :provider
    end

    class Eth < TokenAdapter::Base

      def initialize(config)
        super(config)
        if TokenAdapter::Ethereum.provider
          TokenAdapter::Ethereum.provider = Provider::Rpc
        end
        self.class.send(:include, TokenAdapter::Ethereum.provider)
        init_provider(config)
        @logger = TokenAdapter::Ethereum::Eth.logger || TokenAdapter.logger
      end
  
      # 获取交易所的地址上币
      def getbalance
        get_balance(config[:exchange_address])
      end
  
      def getnewaddress(account, passphrase)
        data = '0xa9b1d507' # Ethereum::Function.calc_id('makeWallet()')
        gas_limit = config[:newaddress_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:newaddress_gas_price] || config[:gas_price] || 20_000_000_000
        address_contract_address = config[:contract_address]

        txhash = send_transaction(from: from, data: data, gas_limit: gas_limit, gas_price: gas_price, to: address_contract_address)
        raise TxHashError, 'txhash is nil' unless txhash

        # 等待上链
        wait_for_miner(txhash)

        # 从回执的logs里找
        receipt = eth_get_transaction_receipt(txhash)
        return nil unless ( receipt && receipt['logs'] && receipt['logs'][0] && receipt['logs'][0]['data'] )
        return eth_address(receipt['logs'][0]['data']), txhash
      end

      # 用户提币
      def sendtoaddress(address, amount)
        gas_limit = config[:transfer_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:transfer_gas_price] || config[:gas_price] || 20_000_000_000

        txhash = send_transaction(from: from, value: amount, gas_limit: gas_limit, gas_price: gas_price, to: address)
        raise TxHashError, 'txhash is nil' unless txhash
        txhash
      end

      # 用于充值，自己添加的属性，数字是10进制的（原始的是字符串形式的16进制）
      # 严格判断
      def gettransaction(txid)
        tx = eth_get_transaction_by_hash(txid)
        return nil unless (tx && tx['blockNumber']) # 未上链的直接返回nil，有没有可能之后又上链了？

        receipt = eth_get_transaction_receipt(tx['hash'])
        raise TransactionError, 'Transaction Fail' if (receipt['status'] && receipt['status'] == '0x0')
        raise TransactionError, 'out of gas' if out_of_gas?(tx, receipt)

        # 把回执也作为tx的一部分返回
        tx['receipt'] = receipt

        # 确认数
        current_block_number = eth_block_number # 当前的高度
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
        nil
      end

      def get_balance(address)
        result = eth_get_balance(address)
        result.to_f
      end

      def get_total_balance(addresses)
        addresses.reduce(0) do |sum, address|
          sum + get_balance(address)
        end
      end

      private

      def from
        exchange_address_priv = config[:exchange_address_priv]
        exchange_address = config[:exchange_address]
        exchange_address_passphrase = config[:exchange_address_passphrase]
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
        return has_event_log?(receipt, config[:token_contract_address], topics, data)
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

      # nil or rawtx
      def generate_raw_transaction(priv, value, data, gas_limit, gas_price, to = nil)

        key = ::Eth::Key.new priv: priv
        address = key.address

        transaction_count = eth_get_transaction_count(address, 'pending')
        args = {
          from: address,
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

      def no_pending?(address)
        no_pending = false
        10.times do
          transaction_count = eth_get_transaction_count(address)
          pending_transaction_count = eth_get_transaction_count(address, 'pending')
          if transaction_count === pending_transaction_count
            no_pending = true
            break
          end
          sleep 6
        end

        return no_pending
      end

      def send_transaction(from: nil, value: nil, data: nil, gas_limit: 200_000, gas_price: 20_000_000_000, to: nil)
        if from.is_a? String
          send_transaction_to_external(from, value, data, gas_limit, gas_price, to)
        else
          send_transaction_to_internal(from[:address], from[:passphrase], value, data, gas_limit, gas_price, to)
        end

      end

      def send_transaction_to_external(priv, value, data, gas_limit, gas_price, to = nil)
        # txhash = nil
        # TokenAdapter.mutex.synchronize(priv) do
          rawtx = generate_raw_transaction(priv, value, data, gas_limit, gas_price, to)
          txhash = eth_send_raw_transaction(rawtx) if rawtx
        # end
        return txhash
      end

      def send_transaction_to_internal(from, passphrase, value, data, gas_limit, gas_price, to = nil)
        personal_unlock_account(from, passphrase)
        if value
          value_in_wei = (value * (10**config[:token_decimals])).to_i
          v = dec_to_hex(value_in_wei)
        else
          v = nil
        end

        eth_send_transaction(
            (from.nil? ? nil : from),
            (to.nil? ? nil : to),
            dec_to_hex(gas_limit),
            dec_to_hex(gas_price),
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
        not result['blockNumber'].nil?
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
