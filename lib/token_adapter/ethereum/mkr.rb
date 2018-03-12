module TokenAdapter
  module Ethereum
    class Mkr < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xc66ea802717bfb9833400264dd12c2bceaa34a6d'
        @token_decimals = 18
      end
    end
  end
end
