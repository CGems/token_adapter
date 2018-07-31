module TokenAdapter
  module Ethereum
    class Tba < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x3c673c02b401a1db9fda6ebcdf4ddca7be6400a8'
        @token_decimals = 18
      end
    end
  end
end
