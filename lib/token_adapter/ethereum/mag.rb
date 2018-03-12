module TokenAdapter
  module Ethereum
    class Mag < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x647f274b3a7248d6cf51b35f08e7e7fd6edfb271'
        @token_decimals = 0
      end
    end
  end
end
