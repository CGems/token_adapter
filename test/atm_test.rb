require "test_helper"

class AtmTest < Minitest::Test
  def setup
    TokenAdapter.logger = Logger.new(STDOUT)
    TokenAdapter::Ethereum.provider = TokenAdapter::Ethereum::Provider::Rpc
    @atm_config = {
      exchange_address: "0x5C13A82fF280Cdd8E6fa12C887652e5De1cD65a8",
      exchange_address_passphrase: "ed018608",
      contract_address: "0x826c6ee06c89b2f8ceb39ebc3153a6e7553a2ebe", # 生成地址的时候使用的合约
      gas_limit: 200000,
      gas_price: 20000000000, # 20gwei
      token_decimals: 8,
      token_contract_address: "0xda1e6a532b15f5f6d8e6504a67eadb88305ac5f9", # token的合约地址

      rpc: 'http://47.52.31.232:8545',
      adapter: 'TokenAdapter::Ethereum::Atm'
    }
    @atm = TokenAdapter::Ethereum::Atm.new(@atm_config)
  end

  def test_gettransaction
    tx = @atm.gettransaction('0xecc376e9d3842df96dab11ad03b4c15ee678ed152d250c2c4233774078ba7671')
    assert_equal tx.nil?, false
  end

  def test_get_a_fail_transaction
    tx = @atm.gettransaction('0x625bc651b0f1763b338c4c4a45613971acc64837d379b82bfc7298f26224fe68')
  end
end