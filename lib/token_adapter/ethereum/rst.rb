module TokenAdapter
  module Ethereum
    class Rst < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x8c01722fc426841e7f508d2aadc9678b79228281'
        @token_decimals = 8
      end
    end
  end
end
