module TokenAdapter
  module Ethereum
    class Bkc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x9fAB652aBd7651E7f46D18522eE4710d9214F8A8'
        @token_decimals = 8
      end
    end
  end
end
