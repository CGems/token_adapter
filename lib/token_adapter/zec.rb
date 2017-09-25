module TokenAdapter
  class Zec < Btc

    def initialize(config)
      super(config)
    end

    def getnewaddress(account, passphase)
      fetch method: 'getnewaddress', params: []
    end
  end
end
