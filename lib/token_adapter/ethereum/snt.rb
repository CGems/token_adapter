module TokenAdapter
  module Ethereum
    class Snt < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Snt.logger || TokenAdapter.logger
      end
    end
  end
end
