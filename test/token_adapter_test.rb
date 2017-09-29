require "test_helper"

class TokenAdapterTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    # TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Etherscan
    # TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Infura
    TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Rpc

    @eth_config = {
      exchange_address: "0x5c13a82ff280cdd8e6fa12c887652e5de1cd65a8",
      exchange_address_priv: "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c",
      contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe",
      gas_limit: 200000,
      gas_price: 20000000000, # 20gwei

      etherscan_api_key: "CQZEXX84G6AQ5R8AZCII626EA43VPNJEEU",
      infura_token: 'fEgf2OPCz9nuea7QCvxn',
      chain: 'ropsten', # one of mainnet, kovan, ropsten, rinkeby

      rpc: 'https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn'
    }

    @atm_config = {
      exchange_address: "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8",
      exchange_address_priv: "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c",
      contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe", # 生成地址的时候使用的合约
      gas_limit: 200000,
      gas_price: 20000000000, # 20gwei

      token_decimals: 8,
      token_contract_address: "0xda1e6a532b15f5f6d8e6504a67eadb88305ac5f9", # token的合约地址

      etherscan_api_key: "CQZEXX84G6AQ5R8AZCII626EA43VPNJEEU",
      infura_token: 'fEgf2OPCz9nuea7QCvxn',
      chain: 'ropsten',

      rpc: 'https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn'
    }
    @eth = TokenAdapter::Ethereum::Eth.new(@eth_config)
    @atm = TokenAdapter::Ethereum::Atm.new(@atm_config)
  end

  def test_that_it_has_a_version_number
    refute_nil ::TokenAdapter::VERSION
  end

  def test_eth_getbalance
    balance = @eth.getbalance
    assert_kind_of Float, balance
    puts balance
  end

  def test_atm_getbalace
    balance = @atm.getbalance
    assert_kind_of Fixnum, balance
    puts balance
  end

  def test_atm_sendtoaddress
    txhash = @atm.sendtoaddress('0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', 5)
    assert_kind_of String, txhash
    assert_match /^0x[a-f0-9]*/, txhash
  end

  def test_eth_get_total_balance
    balance = @eth.get_total_balance(['0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', '0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8'])
    assert_kind_of Float, balance
    puts balance
  end
end
