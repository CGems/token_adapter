module TokenAdapter
  module Bilur
    class Mox < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = ''
        @token_decimals = 8
      end
    end
  end
end
