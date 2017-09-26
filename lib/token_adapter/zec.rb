module TokenAdapter
  class Zec < Btc

    def initialize(config)
      super(config)
    end

    def getnewaddress(account, passphrase)
      fetch method: 'getnewaddress', params: []
    end
  end
end
