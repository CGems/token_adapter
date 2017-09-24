module TokenAdapter
  module Ethereum

    class << self
      attr_accessor :provider
    end

    class Eth < TokenAdapter::Base
  
      def initialize(config)
        super(config)
        self.class.send(:include, TokenAdapter::Ethereum.provider)
        init_provider(config)
      end
  
      # 获取交易所的地址上币
      def getbalance
        result = eth_get_balance(config[:exchange_address])
        result.to_f / 10**18
      end
  
      def getnewaddress(account, passphase)
        priv = config[:exchange_address_priv]
        address_contract_address = config[:contract_address]
        gas_limit = config[:newaddress_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:newaddress_gas_price] || config[:gas_price] || 20_000_000_000
  
        # 生成raw tx
        data = '0xa9b1d507' # Ethereum::Function.calc_id('makeWallet()')
        to = address_contract_address
        rawtx = generate_raw_transaction(priv, nil, data, gas_limit, gas_price, to)
        return nil unless rawtx
  
        # 执行raw tx
        txhash = eth_send_raw_transaction(rawtx)
        return nil unless txhash

        # 等待上链
        wait_for_miner(txhash)

        # 从回执的logs里找
        receipt = eth_get_transaction_receipt(txhash)
        return nil unless ( receipt && receipt['logs'] && receipt['logs'][0] && receipt['logs'][0]['data'] )
        return eth_address(receipt['logs'][0]['data'])
      end
  
      # 用户提币
      def sendtoaddress(address, amount)
        gas_limit = config[:transfer_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:transfer_gas_price] || config[:gas_price] || 20_000_000_000
        rawtx = generate_raw_transaction(config[:exchange_address_priv],
                                         amount,
                                         nil,
                                         gas_limit,
                                         gas_price,
                                         address)
        return nil unless rawtx
  
        eth_send_raw_transaction(rawtx)
      end
  
      # 用于充值，自己添加的属性，数字是10进制的（原始的是字符串形式的16进制）
      # 严格判断
      def gettransaction(txid)
        tx = eth_get_transaction_by_hash(txid)
        return nil unless (tx && tx['blockNumber']) # 未上链的直接返回nil，有没有可能之后又上链了？
  
        receipt = eth_get_transaction_receipt(txhash)
        return nil if out_of_gas?(tx, receipt)
  
        # 把回执也作为tx的一部分返回
        tx['receipt'] = receipt
  
        # 确认数
        current_block_number = eth_block_number # 当前的高度
        return nil unless current_block_number
        transaction_block_number = hex_to_dec(tx['blockNumber'])
        tx['confirmations'] = current_block_number - transaction_block_number
  
        # 上链时间
        block = get_block_by_number(tx['blockNumber'])
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
  
      def wallet_collect(wallet_address, token_address, amount, token_decimals)
        function_signature = '6ea056a9' # Ethereum::Function.calc_id('sweep(address,uint256)')
  
        amount_in_wei = (amount*(10**token_decimals)).to_i
        data = "0x#{function_signature}#{padding(token_address)}#{padding(dec_to_hex(amount_in_wei))}"
  
        gas_limit = config[:collect_gas_limit] || config[:gas_limit] || 200_000
        gas_price = config[:collect_gas_price] || config[:gas_price] || 20_000_000_000
        rawtx = generate_raw_transaction(config[:exchange_address_priv],
                                         nil,
                                         data,
                                         gas_limit,
                                         gas_price,
                                         wallet_address)
  
        return nil unless rawtx
  
        txhash = eth_send_raw_transaction(rawtx)
  
        return nil if hex_to_dec(txhash) == 0
        return txhash
      end

    end
  end
end
