module TokenAdapter
  module Ethereum
    class Datx < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xabbbb6447b68ffd6141da77c18c7b5876ed6c5ab'
        @token_decimals = 18
      end
    end
  end
end
