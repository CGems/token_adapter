module TokenAdapter
  module JsonRpc

    def conn
      @conn ||= Faraday.new(url: @rpc)
    end

    def json_rpc(method:, params:)
      {
          "jsonrpc" => "2.0",
          "method"  => method,
          "params"  => params,
          "id"      => 1
      }
    end

    def fetch(method:, params:)
      request_content = json_rpc(method: method, params: params).to_json
      TokenAdapter.logger.debug "post: #{@rpc}"
      TokenAdapter.logger.debug "     params: #{request_content}"
      resp = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = request_content
      end
      TokenAdapter.logger.debug "     result: #{resp.body}"
      data = JSON.parse(resp.body)
      raise TokenAdapter::JSONRPCError, data['error'] if data['error']
      data['result']
    rescue Errno::ECONNREFUSED => e
      raise TokenAdapter::JSONRPCError, e.message
    end

    # params example: 
    # [ 
    #   { method: 'eth_sendRawTransaction', params: [ "xxx" ], id: 1 },
    #   { method: 'eth_sendRawTransaction', params: [ "xxx" ], id: 2 }
    # ]
    def batch_fetch(args)
      params = args.collect do |arg|
        {
          "jsonrpc" => "2.0",
          "method"  => arg[:method],
          "params"  => arg[:params],
          "id"      => arg[:id]
        }
      end

      resp = conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      if resp.status == 200
        data = JSON.parse(resp.body)
      else
        data = []
      end
    end
  end
end
