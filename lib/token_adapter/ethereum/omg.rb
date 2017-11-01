module TokenAdapter
  module Ethereum
    class Omg < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Omg.logger || TokenAdapter.logger
      end
    end
  end
end
