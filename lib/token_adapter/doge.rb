module TokenAdapter
  class Doge < Btc

    def initialize(config)
      super(config)
      @logger = TokenAdapter::Doge.logger || TokenAdapter.logger
    end

  end
end
