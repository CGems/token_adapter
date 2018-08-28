module TokenAdapter
  module Ethereum
    class Bb < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x0605dd524bdbe8c3edde6ebe59600011328243d9'
        @token_decimals = 18
      end
    end
  end
end
