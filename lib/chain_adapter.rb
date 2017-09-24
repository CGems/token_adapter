require 'etherscan'
require 'infura'
require 'eth'
require 'pattern-match'


module ChainAdapter
  class << self
    attr_accessor :logger
  end

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end
end


require "chain_adapter/version"
require "chain_adapter/base"
require "chain_adapter/eth/base_provider"
require "chain_adapter/eth/etherscan_provider"
require "chain_adapter/eth/infura_provider"
require "chain_adapter/eth/rpc_provider"
require "chain_adapter/eth/eth"
require "chain_adapter/eth/erc20"
require "chain_adapter/eth/atm"
require "chain_adapter/btc"
require "chain_adapter/ltc"
require "chain_adapter/zec"
require "chain_adapter/doge"




