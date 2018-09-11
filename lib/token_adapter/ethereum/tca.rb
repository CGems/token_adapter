module TokenAdapter
  module Ethereum
    class Tca < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xfA0eF5E034CaE1AE752d59bdb8aDcDe37Ed7aB97'
        @token_decimals = 18
      end
    end
  end
end
