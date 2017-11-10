module TokenAdapter
  module Ethereum
    class Mkr < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Mkr.logger || TokenAdapter.logger
      end
    end
  end
end
