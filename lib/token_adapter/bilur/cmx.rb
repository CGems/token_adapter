module TokenAdapter
  module Bilur
    class Cmx < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0x29f9fa94939de2b43bb7ea963e82529b9c85917a'
        @token_decimals = 8
      end
    end
  end
end
