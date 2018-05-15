require_relative "test_helper"
require "logger"

class ExtTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter::Ethereum.xpub = 'xpub6Es3yEf4WQqtXuLie35RNB2gdKpWhy5t27rGw8zExGDzH71pXPG5n9mLVieai71BsbBuMqEBrVdKdyY2VZ2LsMVUSG1WzgoPPww7RDctrG6'
    TokenAdapter::Ethereum.rpc_endpoint = "https://ropsten.infura.io/fEgf2OPCz9nuea7QCvxn"
    TokenAdapter::Ethereum.exchange_address = "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8"
    TokenAdapter::Ethereum.exchange_address_priv = "2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c"
    TokenAdapter::Ethereum.contract_address = "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe"
    TokenAdapter::Ethereum.newaddress_gas_limit = 200000
    TokenAdapter::Ethereum.transfer_gas_limit = 60000
    TokenAdapter::Ethereum.collect_gas_limit = 200000

    @config = {}

    @api = TokenAdapter::Ethereum::Ext.new(@config)
  end

  # def test_getnewaddress
  #   address = @api.getnewaddress(1, '')
  #   assert_equal '0x197b021335cabe47bc1be183d6e444e8063900ae', address
  # end

  # def test_sendtoaddress
  #   txhash = @api.sendtoaddress('0xE7DdCa8F81F051330CA748E82682b1Aa4cd8054F', 5)
  #   assert_kind_of String, txhash
  #   assert_match /^0x[a-f0-9]*/, txhash
  # end

  # def test_gettransaction
  #   tx = @api.gettransaction('0x4b3f5a4cdc5c60b7163c68f2dbd32100bbe4e741a0ca15a5a91a5d4b9a31de66')
  #   assert_equal false, tx.nil?
  # end
end