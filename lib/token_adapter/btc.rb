module TokenAdapter
  class Btc < Base
    include TokenAdapter::JsonRpc

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
    end

    def getnewaddress(account, passphrase)
      fetch method: 'getnewaddress', params: [account]
    end

    def settxfee(fee)
      # do nothing
    end

    def transaction_status(txid)
      :successed
    end

    def method_missing(name, *args)
      fetch method: name, params: args
    end
  end
end
