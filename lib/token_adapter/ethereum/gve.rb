module TokenAdapter
  module Ethereum
    class Gve < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x7421eeb947c7bbabab27aeac6ee2f327e2917cb'
        @token_decimals = 18
      end
    end
  end
end
