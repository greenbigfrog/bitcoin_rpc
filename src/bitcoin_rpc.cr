require "http/client"
require "json"
require "uri"

require "./bitcoin_rpc/*"

class BitcoinRpc
  def initialize(uri : String, username : String, password : String)
    @url = URI.parse(uri)
    @headers = HTTP::Headers{"Content-Type" => "application/json"}
    @username = username
    @password = password
  end

  macro method_missing(call)
    command = {{call.name.id.stringify.gsub /_/, ""}}
    {% if call.args.size == 0 %}
      rpc_request(command)
    {% else %}
      rpc_request(command, {{call.args}})
    {% end %}
  end

  private def rpc_request(command, params = [] of String)
    body = {
      :method => command,
      :params => params,
    }.to_json

    client = HTTP::Client.new(@url)
    client.basic_auth(@username, @password)

    response = client.post("/", headers: @headers, body: body)

    client.close
    parse_response(response)
  end

  private def parse_response(response : HTTP::Client::Response)
    payload = JSON.parse(response.body).as_h

    # Raising with the whole error here, to allow comparsion by Error Code
    # https://github.com/bitcoin/bitcoin/blob/v0.15.0.1/src/rpc/protocol.h#L32L87
    #
    # ```
    # begin
    #   rpc.send_to_address("nhaCeQinqphv61epDKcAbqgn6nBXUWAjPc", 1000000, "test")
    # rescue exception
    #   msg = exception.message
    #   raise "No Exception Message" unless msg
    #   JSON.parse(msg)["code"] == -6 # -6 == Insufficient Funds
    # end
    # ```
    raise payload["error"].to_json if payload["error"]

    payload["result"]
  end
end
