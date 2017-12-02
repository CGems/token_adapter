module TokenAdapter
  module Ethereum
    class Cxt < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Cxt.logger || TokenAdapter.logger
      end
    end
  end
end
