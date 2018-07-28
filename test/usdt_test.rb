require_relative "test_helper"
require "logger"

class UsdtTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter.logger.level = Logger::INFO

    @usdt = TokenAdapter::Usdt.new({})
  end


  def test_getnewaddress
    address = @usdt.getnewaddress(nil, nil)
    assert_equal 34, address.length
  end

  def test_getbalance
    balance = @usdt.getbalance
    assert_equal Float, balance.class
  end

  def test_sendtoaddress
    sn = @usdt.sendtoaddress 'mo6AmvaNz8GhQPJPYaf75d9h4SppFfve15', 0.01
    assert_equal '25708503200956425'.length, sn.length
  end

  def test_gettransaction
    tx = @usdt.gettransaction('25708503200956428')
    assert_equal Hash, tx.class

  end
end
