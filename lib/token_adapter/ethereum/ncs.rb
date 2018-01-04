module TokenAdapter
  module Ethereum
    class Ncs < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Ncs.logger || TokenAdapter.logger
      end
    end
  end
end
