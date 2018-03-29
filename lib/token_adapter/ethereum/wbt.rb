module TokenAdapter
  module Ethereum
    class Wbt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xe2eb8871aecab528e3a36bf8a9b2d9a044b39626'
        @token_decimals = 18
      end
    end
  end
end
