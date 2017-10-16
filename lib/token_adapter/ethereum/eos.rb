module TokenAdapter
  module Ethereum
    class Eos < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Eos.logger || TokenAdapter.logger
      end
    end
  end
end
