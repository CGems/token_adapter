require "test_helper"

class AtmInfuraTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Rpc
    @config = {
        exchange_address: "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8",
        exchange_address_passphrase: "ed018608",
        contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe", # 生成地址的时候使用的合约
        token_decimals: 8,
        token_contract_address: "0xda1e6a532b15f5f6d8e6504a67eadb88305ac5f9", # token的合约地址

        infura_token: 'fEgf2OPCz9nuea7QCvxn',
        chain: 'ropsten',
        exchange_address_priv: '2f832c0c03c67d344f110df6ae37daf8181db66eb1efad3e63cfe55c2029a02c'
    }
    @atm = TokenAdapter::Ethereum::Atm.new(@config)
  end

  def test_gettransaction
    tx = @atm.gettransaction('0xecc376e9d3842df96dab11ad03b4c15ee678ed152d250c2c4233774078ba7671')
    assert_equal tx.nil?, false
  end
end