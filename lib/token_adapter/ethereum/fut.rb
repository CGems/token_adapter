module TokenAdapter
  module Ethereum
    class Fut < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Fut.logger || TokenAdapter.logger
      end
    end
  end
end
