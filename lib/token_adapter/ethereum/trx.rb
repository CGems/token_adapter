module TokenAdapter
  module Ethereum
    class Trx < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xf230b790e05390fc8295f4d3f60332c93bed42e2'
        @token_decimals = 6
      end
    end
  end
end
