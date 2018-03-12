module TokenAdapter
  module Ethereum
    class Egt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x15b683f780736217a34a058ec8179595e8a84c5b'
        @token_decimals = 8
      end
    end
  end
end
