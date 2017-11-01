module TokenAdapter
  module Ethereum
    class Bat < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Bat.logger || TokenAdapter.logger
      end
    end
  end
end
