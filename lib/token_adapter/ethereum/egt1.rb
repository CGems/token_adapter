module TokenAdapter
  module Ethereum
    class Egt1 < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x9B11EFcAAA1890f6eE52C6bB7CF8153aC5d74139'
        @token_decimals = 8
      end
    end
  end
end
