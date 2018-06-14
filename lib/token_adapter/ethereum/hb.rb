module TokenAdapter
  module Ethereum
    class Hb < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xd2cdce6d77604123eabd57bd522a18a28f29f0c7'
        @token_decimals = 18
      end
    end
  end
end
