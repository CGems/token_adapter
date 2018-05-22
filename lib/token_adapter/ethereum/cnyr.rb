module TokenAdapter
  module Ethereum
    class Cnyr < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x41005c6c3f311405faecca85ded58fb55e4bbb86'
        @token_decimals = 8
      end
    end
  end
end
