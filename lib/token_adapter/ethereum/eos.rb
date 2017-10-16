module TokenAdapter
  module Ethereum
    class Eos < Erc20
      def initialize(config)
        super(config)
      end
    end
  end
end
