module TokenAdapter
  module Ethereum
    class << self
      attr_accessor :rpc_endpoint, 
                    :exchange_address, :exchange_address_priv, :exchange_address_passphrase,
                    :contract_address, :newaddress_gas_limit, :newaddress_gas_price,
                    :transfer_gas_limit, :transfer_gas_price,
                    :collect_gas_limit, :collect_gas_price,
                    :xpub


      
    end
  end
end