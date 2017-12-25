module TokenAdapter
  module Ethereum
    class Trx < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Trx.logger || TokenAdapter.logger
      end
    end
  end
end
