module TokenAdapter
  module Ethereum
    class Moac < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xCBcE61316759D807c474441952cE41985bBC5a40'
        @token_decimals = 18
      end
    end
  end
end
