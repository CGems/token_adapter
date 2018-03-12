module TokenAdapter
  module Ethereum
    class Bat < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x0d8775f648430679a709e98d2b0cb6250d2887ef'
        @token_decimals = 18
      end
    end
  end
end
