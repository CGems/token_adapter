module TokenAdapter
  module Ethereum
    class Bkc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x262377e5956f2fc32d8024c0c9282fe0c53da24c'
        @token_decimals = 8
      end
    end
  end
end
