module TokenAdapter
  module Bilur
    class Mox < Erc40
      def initialize(config)
        super(config)
        @token_contract_address = '0x1f69920a1687197e62b8db1226eb7ce5b0614387'
        @token_decimals = 8
      end
    end
  end
end
