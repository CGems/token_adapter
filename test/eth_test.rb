require_relative "test_helper"
require "logger"

class EthTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter.logger.level = Logger::INFO
    TokenAdapter::Ethereum.rpc_endpoint = "https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn"
    TokenAdapter::Ethereum.exchange_address = "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8"
    TokenAdapter::Ethereum.exchange_address_priv = "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c"
    TokenAdapter::Ethereum.xpub = "xpub6ErYnsUHKoAuMEJvAqcHX5LjUqkFkEaMzGCq2YYNuZXaaB4LfRKZZHxYV28Lkp4d6CojkuhN8fuyRjEgeMX9VTkNPzXgticvUvYzsSQyCcw"
    TokenAdapter::Ethereum.transfer_gas_limit = 60000

    @eth = TokenAdapter::Ethereum::Eth.new({})
  end

  def test_getbalance
    result = @eth.getbalance
    assert_equal true, result > 0
  end

  def test_getnewaddress
    address = @eth.getnewaddress(111, '')
    assert_equal 42, address.length
  end

  def test_sendtoaddress_without_sufficient_funds
    @eth.sendtoaddress('0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', 100)
  rescue TokenAdapter::JSONRPCError => ex
    assert_equal '{"code"=>-32000, "message"=>"insufficient funds for gas * price + value"}', ex.message
  end

  def test_gettransaction
    tx = @eth.gettransaction('0xecc376e9d3842df96dab11ad03b4c15ee678ed152d250c2c4233774078ba7671')
    assert_equal false, tx.nil?
  end

  def test_generate_raw_transaction
    
  end
end