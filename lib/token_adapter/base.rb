module TokenAdapter
  class Base
    attr_reader :config
    attr_accessor :logger

    class << self
      attr_accessor :logger
    end

    def initialize(config)
      @config = config
    end
  end
end

