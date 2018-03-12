module TokenAdapter
  module Ethereum
    class Bpt < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xcbbE432D9f844e5548e9053aF0348e3779259FD1'
        @token_decimals = 8
      end
    end
  end
end
