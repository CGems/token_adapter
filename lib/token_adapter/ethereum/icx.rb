module TokenAdapter
  module Ethereum
    class Icx < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Icx.logger || TokenAdapter.logger
      end
    end
  end
end
