module TokenAdapter
  module Ethereum
    class Cnst < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x3437d06cd9111c828075c12265ed66c5e9f001f1'
        @token_decimals = 8
      end
    end
  end
end
