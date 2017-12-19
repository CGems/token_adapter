module TokenAdapter
  module Ethereum
    class Bpt < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Bpt.logger || TokenAdapter.logger
      end
    end
  end
end
