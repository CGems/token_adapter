module TokenAdapter
  module Ethereum
    class Gve < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x81705082ef9f0d660f07be80093d46d826d48b25'
        @token_decimals = 18
      end
    end
  end
end
