require "test_helper"
require "remote_lock"
require "redis"

class TestLock < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter.redis_connection = Redis.new(host: "127.0.0.1", port: 6379, db: 15)
    TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Rpc

    @eth_config = {
      exchange_address: "0x5c13a82ff280cdd8e6fa12c887652e5de1cd65a8",
      exchange_address_priv: "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c",
      contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe",
      gas_limit: 200000,
      gas_price: 20000000000, # 20gwei
      rpc: 'https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn'
    }
    @eth = TokenAdapter::Ethereum::Eth.new(@eth_config)
  end

  def test_get_mutex
    mutex = TokenAdapter.mutex
    assert_kind_of RemoteLock, mutex
  end
end
