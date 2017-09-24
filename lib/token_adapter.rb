require 'etherscan'
require 'infura'
require 'eth'
require 'pattern-match'

module TokenAdapter
  class << self
    attr_accessor :logger
  end

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end
end

require "token_adapter/json_rpc"
require "token_adapter/ethereum/provider/base"
require "token_adapter/ethereum/provider/etherscan"
require "token_adapter/ethereum/provider/infura"
require "token_adapter/ethereum/provider/rpc"
require "token_adapter/version"
require "token_adapter/base"
require "token_adapter/ethereum/eth"
require "token_adapter/ethereum/erc20"
require "token_adapter/ethereum/atm"
require "token_adapter/btc"
require "token_adapter/ltc"
require "token_adapter/zec"
require "token_adapter/doge"




