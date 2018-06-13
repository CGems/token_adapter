module TokenAdapter
  module Ethereum
    class Mvp < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0x8a77e40936bbc27e80e9a3f526368c967869c86d'
        @token_decimals = 18
      end
    end
  end
end
