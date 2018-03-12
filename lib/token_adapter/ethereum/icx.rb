module TokenAdapter
  module Ethereum
    class Icx < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xb5a5f22694352c15b00323844ad545abb2b11028'
        @token_decimals = 18
      end
    end
  end
end
