module TokenAdapter
  class Zec < Btc

    def initialize(config)
      super(config)
    end

    def getnewaddress(account, passphase)
      call 'getnewaddress'
    end
  end
end
