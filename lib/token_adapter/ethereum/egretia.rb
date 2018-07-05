module TokenAdapter
  module Ethereum
    class Egretia < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x8e1b448ec7adfc7fa35fc2e885678bd323176e34'
        @token_decimals = 18
      end
    end
  end
end
