module TokenAdapter
  module Ethereum
    class Mht < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Mht.logger || TokenAdapter.logger
      end
    end
  end
end
