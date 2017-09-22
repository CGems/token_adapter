require "test_helper"

class ChainAdapterTest < Minitest::Test
  def setup
    @eth_config = {
        exchange_address: "0x5c13a82ff280cdd8e6fa12c887652e5de1cd65a8",
        exchange_address_priv: "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c",
        contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe",
        etherscan_api_key: "CQZEXX84G6AQ5R8AZCII626EA43VPNJEEU",
        chain: 'ropsten', # one of mainnet, kovan, ropsten, rinkeby
        gas_limit: 200000,
        gas_price: 20000000000 # 20gwei
    }
    @eth = ChainAdapter::Eth.new(@eth_config)
  end

  def test_that_it_has_a_version_number
    refute_nil ::ChainAdapter::VERSION
  end

  def test_eth_getbalance
    assert_kind_of Float, @eth.getbalance
  end
end
