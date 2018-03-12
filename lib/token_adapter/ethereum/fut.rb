module TokenAdapter
  module Ethereum
    class Fut < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x027971a9609345ba6f2fa5b0f671cceba5d6ea54'
        @token_decimals = 8
      end
    end
  end
end
