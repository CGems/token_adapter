module TokenAdapter
  module Ethereum
    class Wicc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x4f878c0852722b0976a955d68b376e4cd4ae99e5'
        @token_decimals = 8
      end
    end
  end
end
