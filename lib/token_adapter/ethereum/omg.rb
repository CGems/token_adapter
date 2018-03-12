module TokenAdapter
  module Ethereum
    class Omg < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xd26114cd6EE289AccF82350c8d8487fedB8A0C07'
        @token_decimals = 18
      end
    end
  end
end
