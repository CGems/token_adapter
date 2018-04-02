module TokenAdapter
  class UnsupportedProperty < StandardError; end
  class Usdt < Btc
    include TokenAdapter::JsonRpc

    #propertyid
    USDT_PROPERTY_ID = 31

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
    end

    def getbalance(address = nil)
      address ||= from
      balance_info = fetch(method: 'omni_getbalance', params: [address, USDT_PROPERTY_ID])
      return balance_info['balance']
    end

    def settxfee(fee)
      # do nothing
    end

    def sendtoaddress(address, amount)
      return fetch(method: 'omni_send', params: [from, address, USDT_PROPERTY_ID, amount]), nil
    end

    def gettransaction(txid)
      tx = fetch(method: 'omni_gettransaction', params: [txid])
      raise UnsupportedProperty, 'Unsupported property' if tx['propertyid'] != USDT_PROPERTY_ID
      tx['timereceived'] = tx['blocktime']
      # 保持和btc返回结构一致
      tx['details'] = [
        {
          'account' => 'payment',
          'category' => 'receive',
          'amount' => tx['amount'],
          'address' => tx['referenceaddress']
        }
      ]
      tx
    end

    def method_missing(name, *args)
      fetch method: name, params: args
    end

    private

    def from
      from = config[:assets]['accounts'][0]['address']
      from
    end
  end
end
