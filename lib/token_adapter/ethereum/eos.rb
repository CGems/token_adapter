module TokenAdapter
  module Ethereum
    class Eos < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0'
        @token_decimals = 18
      end
    end
  end
end
