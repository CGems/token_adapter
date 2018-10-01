module TokenAdapter
  module Bilur
    class Rst < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0xc4f86469d90a13d70e5142f9cd1df5b6abd53120'
        @token_decimals = 8
      end
    end
  end
end
