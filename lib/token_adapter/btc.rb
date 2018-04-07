module TokenAdapter
  class Btc < Base
    include TokenAdapter::JsonRpc

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
    end

    def getnewaddress(account, passphrase)
      return fetch(method: 'getnewaddress', params: ['payment'])
    end

    def settxfee(fee)
      # do nothing
    end
    
    def getaddressesbyaccount(account = nil)
      account ||= 'payment'
      return fetch(method: 'getaddressesbyaccount', params: [account.to_s])
    end
    
    def getreceivedbyaddress(address)
      return fetch(method: 'getreceivedbyaddress', params: [address])
    end

    def transaction_status(txid)
      :successed
    end

    def method_missing(name, *args)
      fetch method: name, params: args
    end
  end
end
