require 'etherscan'
require "chain_adapter/version"
require "chain_adapter/eth_helper"
require "chain_adapter/base"
require "chain_adapter/eth"
require "chain_adapter/erc20"
require "chain_adapter/atm"

module ChainAdapter
  class << self
    attr_reader :logger

    def logger=(logger)
      @logger = logger
      Etherscan.logger = logger
    end
  end

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end
end

Etherscan.logger = Logger.new(STDOUT)
Etherscan.logger.level = Logger::DEBUG


