module ChainAdapter
  class Btc < Base

    def initialize(config)
      super(config)
      @uri = URI.parse(config[:rpc])
    end

    def getnewaddress(account, passphase)
      call 'getnewaddress', account
    end

    def settxfee(fee)
      # do nothing
    end

    def transaction_status(txid)
      :successed
    end

    def method_missing(name, *args)
      call name, *args
    end

    def call(name, *args)
      data = call2(name, *args)
      if data.class == 'String'
        data
      else
        data[:result]
      end
    end

    def call2(name, *args)
      post_body = prepare_post_body(name, *args)
      ChainAdapter.logger.debug post_body
      resp_body = send_post_request(post_body)
      ChainAdapter.logger.debug resp_body
      resp_body = JSON.parse(resp_body)
      raise ChainAdapter::JSONRPCError, resp_body['error'] if resp_body['error']
      resp_body.deep_symbolize_keys if resp_body.is_a? Hash
    rescue JSON::ParserError => e
      resp_body
    end

    def send_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    rescue Errno::ECONNREFUSED => e
      raise ChainAdapter::ConnectionRefusedError
    rescue => e
      ChainAdapter.logger.error e.message
      ChainAdapter.logger.error e.backtrace.join("\n")
    end

    def prepare_post_body(method, *args)
      { 'method' => method, 'params' => args, 'id' => 'jsonrpc' }.to_json
    end
  end
end
