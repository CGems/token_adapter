require "json"
require "faraday"
require "eth"

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
<<<<<<< HEAD
require "token_adapter/ethereum/erc223"
require "token_adapter/ethereum/ext"
=======
require "token_adapter/ethereum/fllw"
>>>>>>> 5e0f314f8b6c80c7c0f6da3ec1a1c40600875e86
require "token_adapter/btc"
require "token_adapter/ltc"
require "token_adapter/zec"
require "token_adapter/doge"
require "token_adapter/usdt"
