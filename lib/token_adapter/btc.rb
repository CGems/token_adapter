module TokenAdapter
  class Btc < Base
    include TokenAdapter::JsonRpc

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
      @logger = TokenAdapter::Btc.logger || TokenAdapter.logger
    end

    def getnewaddress(account, passphrase)
      return fetch(method: 'getnewaddress', params: [account]), nil
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
