module TokenAdapter
  module Ethereum
    class Mxm < Erc20
      def initialize(config)
        super(config)
       @token_contract_address = '0x6a750d255416483bec1a31ca7050c6dac4263b57'
        @token_decimals = 18
      end
    end
  end
end
