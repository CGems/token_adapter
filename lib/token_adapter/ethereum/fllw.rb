module TokenAdapter
  module Ethereum
    class Fllw < Erc223
      def initialize(config)
        super(config)
        @token_contract_address = '0x0200412995f1bafef0d3f97c4e28ac2515ec1ece'
        @token_decimals = 18
      end
    end
  end
end
