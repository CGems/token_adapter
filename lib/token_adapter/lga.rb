module TokenAdapter
  class Lga < Btc

    include TokenAdapter::JsonRpc

    def initialize(config)
      super(config)
      @rpc = config[:rpc]
    end

    def getbalance(address = nil)
      address ||= from
      balance_info = fetch(method: 'getbalance', params: [address])
      balance = balance_info['name'] == 'lgacoin' ? 0 : balance_info['qty']
      return balance
    end

    def getnewaddress(account, passphrase)
      return fetch(method: 'getnewaddress', params: [])
    end

    def gettransaction(txid)
      tx = fetch(method: 'getrawtransaction', params: [txid])
      tx['timereceived'] = tx['blocktime'] || Time.now.to_i
      # 保持和btc返回结构一致
      details = []
      tx['vout'].each do |out|
        out['assets'].each do |asset|
          if asset['name'] == 'lgacoin'
            details << {
                'account' => 'payment',
                'category' => 'receive',
                'amount' => asset['qty'],
                'address' => out['scriptPubKey']['addresses'][0]
            }
          end
        end
      end
      tx['details'] = details
      tx
    end

    def sendtoaddress(address, amount)
      txhash = fetch(method: 'sendassetfrom', params: [from, address, 'lgacoin', BigDecimal(amount)])
      raise TxHashError, 'txhash is nil' unless txhash
      txhash
    end

    def wallet_collect(address, amount)
      txhash = fetch(method: 'sendassetfrom', params: [address, from, 'lgacoin', BigDecimal(amount)])
      raise TxHashError, 'txhash is nil' unless txhash
      txhash
    end

    def settxfee(fee)
      # do nothing
    end

    def getaddressesbyaccount(account = nil)
      return fetch(method: 'getaddressesbyaccount', params: [''])
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

    private

    def from
      from = config[:assets]['accounts'][0]['address']
      from
    end

  end
end