module TokenAdapter
  class Ltc < Btc

    def initialize(config)
      super(config)
      @logger = TokenAdapter::Ltc.logger || TokenAdapter.logger
    end

  end
end