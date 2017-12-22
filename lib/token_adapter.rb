require 'etherscan'
require 'infura'
require 'eth'
require 'pattern-match'
require 'thread'
require 'remote_lock'

module TokenAdapter
  class << self
    attr_accessor :logger, :redis_connection
    REDIS_LOCK_PREFIX = 'token_adapter_lock'

    def mutex
      @mutex ||= begin
        redis_adapter = RemoteLock::Adapters::Redis.new(redis_connection)
        RemoteLock.new(redis_adapter, REDIS_LOCK_PREFIX)
      end
    end
  end

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end
  class TransactionError < StandardError; end
end

require "token_adapter/json_rpc"
require "token_adapter/ethereum/provider/etherscan"
require "token_adapter/ethereum/provider/infura"
require "token_adapter/ethereum/provider/rpc"
require "token_adapter/version"
require "token_adapter/base"
require "token_adapter/ethereum/eth"
require "token_adapter/ethereum/erc20"
require "token_adapter/ethereum/atm"
require "token_adapter/ethereum/eos"
require "token_adapter/ethereum/snt"
require "token_adapter/ethereum/bat"
require "token_adapter/ethereum/omg"
require "token_adapter/ethereum/mkr"
require "token_adapter/ethereum/mht"
require "token_adapter/ethereum/cxt"
require "token_adapter/ethereum/bpt"
require "token_adapter/ethereum/egt"
require "token_adapter/ethereum/fut"
require "token_adapter/btc"
require "token_adapter/ltc"
require "token_adapter/zec"
require "token_adapter/doge"