module TokenAdapter
  class Zec < Btc

    def initialize(config)
      super(config)
      @logger = TokenAdapter::Zec.logger || TokenAdapter.logger
    end

    def getnewaddress(account, passphrase)
      return fetch(method: 'getnewaddress', params: []), nil
    end
  end
end
