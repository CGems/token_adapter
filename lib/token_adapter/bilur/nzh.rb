module TokenAdapter
  module Bilur
    class Nzh < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0xd24c9007f655219a6dd30fa7151a671e5b65ed9d'
        @token_decimals = 8
      end
    end
  end
end
