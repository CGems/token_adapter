module TokenAdapter
  module Ethereum
    class Mht < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x67a8c7edadd6827056f489abdff85fb5a4b2182c'
        @token_decimals = 4
      end
    end
  end
end
