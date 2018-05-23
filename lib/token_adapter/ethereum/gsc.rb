module TokenAdapter
  module Ethereum
    class Gsc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x228ba514309FFDF03A81a205a6D040E429d6E80C'
        @token_decimals = 18
      end
    end
  end
end
