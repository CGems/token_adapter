module TokenAdapter
  module Ethereum
    class Pfc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xa37d94e80eab7a5bcb6d2e76b7666e341e4b58f6'
        @token_decimals = 18
      end
    end
  end
end
