module TokenAdapter
  module Ethereum
    class Cxtc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x81ce924c7411d7e0c2c000471b1ba77851c99ae6'
        @token_decimals = 18
      end
    end
  end
end
