module TokenAdapter
  module Ethereum
    class Hibt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x9bb1db1445b83213a56d90d331894b3f26218e4e'
        @token_decimals = 18
      end
    end
  end
end
