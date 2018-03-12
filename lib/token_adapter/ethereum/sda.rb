module TokenAdapter
  module Ethereum
    class Sda < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x4212fea9fec90236ecc51e41e2096b16ceb84555'
        @token_decimals = 18
      end
    end
  end
end
