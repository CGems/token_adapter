module TokenAdapter
  module Ethereum
    class Lga < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xb10b10ff2f80c244a6a0191e6e4ee00864a9215e'
        @token_decimals = 8
      end
    end
  end
end
