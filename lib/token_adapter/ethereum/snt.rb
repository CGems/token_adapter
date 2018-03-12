module TokenAdapter
  module Ethereum
    class Snt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x744d70fdbe2ba4cf95131626614a1763df805b9e'
        @token_decimals = 18
      end
    end
  end
end
