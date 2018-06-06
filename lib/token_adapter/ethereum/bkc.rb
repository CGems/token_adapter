module TokenAdapter
  module Ethereum
    class Bkc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x9fab652abd7651e7f46d18522ee4710d9214f8a8'
        @token_decimals = 8
      end
    end
  end
end
