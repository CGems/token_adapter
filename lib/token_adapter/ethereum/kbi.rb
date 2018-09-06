module TokenAdapter
  module Ethereum
    class Kbi < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x6f6eef16939b8327d53afdcaf08a72bba99c1a7f'
        @token_decimals = 18
      end
    end
  end
end
