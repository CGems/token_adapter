require_relative "test_helper"
require "logger"

class AtmTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    @config = {
        exchange_address: "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8",
        exchange_address_priv: '2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c',
        # exchange_address_passphrase: "fuck123456",
        contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe", # 生成地址的时候使用的合约
        gas_limit: 200000,
        token_decimals: 8,
        token_contract_address: "0xda1e6a532b15f5f6d8e6504a67eadb88305ac5f9", # token的合约地址

        rpc: 'https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn'
    }
    @atm = TokenAdapter::Ethereum::Atm.new(@config)
  end

  # def test_getbalance
  #   result = @atm.getbalance
  #   puts '--------------------------'
  #   puts result.class
  #   assert_equal true, result > 0
  # end

  # def test_getnewaddress
  #   address = @eth.getnewaddress('', '')
  #   assert_equal 2, address.length
  #   assert_equal 42, address[0].length
  # end

  # def test_sendtoaddress
  #   txhash = @eth.sendtoaddress('0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', 100)
  #   assert_kind_of String, txhash
  #   assert_match /^0x[a-f0-9]*/, txhash
  #   puts txhash
  # end

  # def test_gettransaction
  #   tx = @eth.gettransaction('0xecc376e9d3842df96dab11ad03b4c15ee678ed152d250c2c4233774078ba7671')
  #   puts tx
  #   assert_equal false, tx.nil?
  # end
end