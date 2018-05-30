module TokenAdapter
  module Ethereum
    class Cmt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xf85feea2fdd81d51177f6b8f35f0e6734ce45f5f'
        @token_decimals = 18
      end
    end
  end
end
