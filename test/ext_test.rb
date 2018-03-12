require_relative "test_helper"
require "logger"

class ExtTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    @config = {
        exchange_address: "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8",
        exchange_address_priv: '2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c',
        contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe", # 生成地址的时候使用的合约
        gas_limit: 200000,
        token_decimals: 4,
        token_contract_address: "0x9c4ddbc1524c3e18cec63c4dd818e62a9b233434", # token的合约地址

        rpc: 'https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn'
    }
    @eth = TokenAdapter::Ethereum::Ext.new(@config)
  end


  # def test_sendtoaddress
  #   txhash = @eth.sendtoaddress('0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', 5)
  #   assert_kind_of String, txhash
  #   assert_match /^0x[a-f0-9]*/, txhash
  #   puts txhash
  # end

  def test_gettransaction
    tx = @eth.gettransaction('0x4b3f5a4cdc5c60b7163c68f2dbd32100bbe4e741a0ca15a5a91a5d4b9a31de66')
    assert_equal false, tx.nil?
  end
end