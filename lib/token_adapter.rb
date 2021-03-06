require "json"
require "faraday"
require "eth"
require "bip44"
require 'bigdecimal'

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
require "token_adapter/ethereum/cnst"
require "token_adapter/ethereum/gsc"
require "token_adapter/ethereum/lga"
require "token_adapter/ethereum/cmt"
require "token_adapter/ethereum/xcc"
require "token_adapter/ethereum/bkc"
require "token_adapter/ethereum/datx"
require "token_adapter/ethereum/mvp"
require "token_adapter/ethereum/hb"
require "token_adapter/ethereum/egretia"
require "token_adapter/ethereum/wicc"
require "token_adapter/ethereum/tba"
require "token_adapter/ethereum/atn"
require "token_adapter/ethereum/bb"
require "token_adapter/ethereum/kbi"
require "token_adapter/ethereum/hibt"
require "token_adapter/ethereum/tca"
require "token_adapter/ethereum/pfc"


require "token_adapter/btc"
require "token_adapter/ltc"
require "token_adapter/zec"
require "token_adapter/doge"
require "token_adapter/usdt"
require "token_adapter/sic"
require "token_adapter/pai"
require "token_adapter/lga"

require "token_adapter/bilur/provider/rpc"
require "token_adapter/bilur"
require "token_adapter/bilur/bpx"
require "token_adapter/bilur/erc20"
# erc40为需要支付基础货币的token
require "token_adapter/bilur/erc40"
require "token_adapter/bilur/mox"
require "token_adapter/bilur/nzh"

require "token_adapter/moac/provider/rpc"
require "token_adapter/moac"
require "token_adapter/moac/moac"

require "token_adapter/gemther/provider/rpc"
require "token_adapter/gemther"
require "token_adapter/gemther/gem"
require "token_adapter/gemther/erc20"
require "token_adapter/gemther/bfc"