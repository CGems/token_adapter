module TokenAdapter
  module Ethereum
    class Atm < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Atm.logger || TokenAdapter.logger
      end
    end
  end
end
