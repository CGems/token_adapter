require 'securerandom'

module TokenAdapter
  class UnsupportedProperty < StandardError; end
  class Usdt

    def initialize(config)
      @conn = Faraday.new(url: "http://localhost:7001")
    end
    
    def getnewaddress(a, b)
      result = http_post '/api/v1/addresses', nil
      result['address']
    end

    def getbalance(address = nil)
      result = http_get '/api/v1/addresses/balance'
      result['balance']
    end
    
    def sendtoaddress(address, amount)
      url = '/api/v1/withdrawals'
      data = %{{"external_sn": "#{Time.now.to_i}#{SecureRandom.hex}", "to": "#{address}", "amount": #{amount}}}
      result = http_post url, data
      result['sn']
    end

    def gettransaction(txid)
      result = http_get '/api/v1/withdrawals/' + txid
      result['timereceived'] = result['updated_at']
      result
    end

    def settxfee(fee)
      # do nothing
    end

    private

    def http_get(url)
      response = @conn.get url 
      result = JSON.parse response.body 
        
      raise result['error'] if result['error']
      result
    end

    def http_post(url, data)
      response = @conn.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = data if data
      end
      result = JSON.parse response.body

      raise result['error'] if result['error']
      result
    end

  end
end
