module TokenAdapter
  module Ethereum
    class Atm < Erc20
      def initialize(config)
        super(config)
      end
    end
  end
end
