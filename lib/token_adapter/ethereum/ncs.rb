module TokenAdapter
  module Ethereum
    class Ncs < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xa60354005b3897bC684244B593fA6F5F18ECd13e'
        @token_decimals = 8
      end
    end
  end
end
