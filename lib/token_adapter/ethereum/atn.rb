module TokenAdapter
  module Ethereum
    class Atn < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x461733c17b0755CA5649B6DB08B3E213FCf22546'
        @token_decimals = 18
      end
    end
  end
end
