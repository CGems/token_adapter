module TokenAdapter
  module Ethereum
    class Ext < Erc223
      def initialize(config)
        super(config)
        @token_contract_address = '0x9c4ddbc1524c3e18cec63c4dd818e62a9b233434'
        @token_decimals = 4
      end
    end
  end
end
