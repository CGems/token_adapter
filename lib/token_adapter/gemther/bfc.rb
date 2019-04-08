module TokenAdapter
  module Gemther
    class Bfc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x3f136045549826bde606f216fdf6cb9e617838ed'
        @token_decimals = 8
      end
    end
  end
end
