module TokenAdapter
  module Ethereum
    class Bpt < Erc20
      def initialize(config)
        super(config)
      end
    end
  end
end
