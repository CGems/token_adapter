module TokenAdapter
  module Ethereum
    class Gst < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x6d245d5985d5cc8c33d6f647e49646d7255767cb'
        @token_decimals = 8
      end
    end
  end
end
