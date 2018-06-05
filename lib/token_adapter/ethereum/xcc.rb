module TokenAdapter
  module Ethereum
    class Xcc < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xb6d945cac888ffc1c76fdbe28e9f50e8b3b8252a'
        @token_decimals = 0
      end
    end
  end
end
