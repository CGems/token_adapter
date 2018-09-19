module TokenAdapter
  class Btc < Base
    include TokenAdapter::JsonRpc

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
    end


    # [  
    #   {  
    #     "txid":"ad25ddd671db5d3170b2bb47f391fd4a524b3da2b0b3fcdc044fb698d7b0a002",
    #     "vout":0,
    #     "address":"mo6AmvaNz8GhQPJPYaf75d9h4SppFfve15",
    #     "account":"",
    #     "scriptPubKey":"76a914531106837f2d7f691f0a248378b2cccf8d17a80388ac",
    #     "amount":0.00000555,
    #     "confirmations":61413,
    #     "spendable":true,
    #     "solvable":true
    #   },
    #   ...
    # ]
    def getbalance(address=nil)
      if address
        utxos = fetch(method: 'listunspent', params: [])
        utxos.reduce(0) do |sum, utxo|
          if utxo['address'] == address and utxo['spendable'] and utxo['confirmations'] >= 1
            sum + utxo['amount']
          else
            sum
          end
        end
      else
        return fetch(method: 'getbalance', params: [])
      end
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
