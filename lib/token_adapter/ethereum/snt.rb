module TokenAdapter
  module Ethereum
    class Snt < Erc20
      def initialize(config)
        super(config)
      end
    end
  end
end
