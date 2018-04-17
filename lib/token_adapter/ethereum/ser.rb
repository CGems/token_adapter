module TokenAdapter
  module Ethereum
    class Ser < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xB561fEF0d624C0826ff869946f6076B7c4f2ba42'
        @token_decimals = 7
      end
    end
  end
end
