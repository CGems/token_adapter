module TokenAdapter
  module Bilur
    class Mox < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0x29f9da254ed1b33ede8edf6d87e988bfd1b9ad06'
        @token_decimals = 8
      end
    end
  end
end
