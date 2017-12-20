module TokenAdapter
  module Ethereum
    class Egt < Erc20
      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum::Egt.logger || TokenAdapter.logger
      end
    end
  end
end
