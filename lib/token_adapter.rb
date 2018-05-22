require "json"
require "faraday"
require "eth"
require "bip44"

module TokenAdapter
  class << self
    attr_accessor :logger
  end

  class JSONRPCError < RuntimeError; end
  class ConnectionRefusedError < StandardError; end
  class TransactionError < StandardError; end
end

require "token_adapter/json_rpc"
require "token_adapter/ethereum/provider/rpc"
require "token_adapter/version"
require "token_adapter/base"
require "token_adapter/ethereum"
require "token_adapter/ethereum/eth"
require "token_adapter/ethereum/erc20"
require "token_adapter/ethereum/atm"
require "token_adapter/ethereum/eos"
require "token_adapter/ethereum/snt"
require "token_adapter/ethereum/bat"
require "token_adapter/ethereum/omg"
require "token_adapter/ethereum/mkr"
require "token_adapter/ethereum/mht"
require "token_adapter/ethereum/cxtc"
require "token_adapter/ethereum/bpt"
require "token_adapter/ethereum/egt"
require "token_adapter/ethereum/fut"
require "token_adapter/ethereum/trx"
require "token_adapter/ethereum/icx"
require "token_adapter/ethereum/ncs"
require "token_adapter/ethereum/sda"
require "token_adapter/ethereum/icc"
require "token_adapter/ethereum/mag"
require "token_adapter/ethereum/erc223"
require "token_adapter/ethereum/ext"
require "token_adapter/ethereum/fllw"
require "token_adapter/ethereum/wbt"
require "token_adapter/ethereum/gst"
require "token_adapter/ethereum/moac"
require "token_adapter/ethereum/ser"
require "token_adapter/ethereum/gve"
require "token_adapter/ethereum/cnyr"

require "token_adapter/btc"
require "token_adapter/ltc"
require "token_adapter/zec"
require "token_adapter/doge"
require "token_adapter/usdt"

require "token_adapter/bilur/provider/rpc"
require "token_adapter/bilur"
require "token_adapter/bilur/bpx"