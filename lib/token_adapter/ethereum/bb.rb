module TokenAdapter
  module Ethereum
    class Bb < Erc20
      def initialize(config)
        super(config)
        @token_contract_address = '0xe4283e601fea362ab08bd90a0baba6a1d1875283'
        @token_decimals = 8
      end
    end
  end
end
