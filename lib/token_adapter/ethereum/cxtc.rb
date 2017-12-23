module TokenAdapter
  module Ethereum
    class Cxtc < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Cxtc.logger || TokenAdapter.logger
      end
    end
  end
end
