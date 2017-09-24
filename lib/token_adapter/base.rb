module TokenAdapter
  class Base
    attr_reader :config

    def initialize(config)
      @config = config
    end
  end
end

