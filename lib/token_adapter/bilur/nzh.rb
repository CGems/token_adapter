module TokenAdapter
  module Bilur
    class Nzh < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0xc27f3903bac479f98e69c6e4080dbcdda232ffa8'
        @token_decimals = 8
      end
    end
  end
end
