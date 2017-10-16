module TokenAdapter
  module Ethereum
    class Atm < Erc20
      attr_accessor :logger

      class << self
        attr_accessor :logger
      end

      def initialize(config)
        super(config)
        @logger = TokenAdapter::Ethereum.Atm.logger || TokenAdapter.logger
      end
    end
  end
end
