module TokenAdapter
  module Ethereum
    class Icc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xedc502b12ced7e16ce21749e7161f9ed22bfca53'
        @token_decimals = 4
      end
    end
  end
end
