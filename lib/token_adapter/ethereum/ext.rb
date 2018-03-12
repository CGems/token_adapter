module TokenAdapter
  module Ethereum
    class Ext < Erc223
      def initialize(config)
        super(config)
      end
    end
  end
end
