require 'nori'
require 'savon'

module PayEx::API
  extend self

  class ParamError < StandardError; end

  def invoke! wsdl, name, params, specs
    response = invoke_raw! wsdl, name,
      PayEx::API::Util.get_request_body(params, specs)

    # Unwrap e.g. <Initialize8Response>
    response = response[response.keys.first]
    # Unwrap e.g. <Initialize8Result>
    response = response[response.keys.first]
    # Parse embedded XML document
    response = Nori.parse(response)
    # Unwrap <payex>
    response = response[response.keys.first]

    if ok = response[:status][:code] == 'OK' rescue false
      response
    elsif defined? response[:status][:description]
      raise PayEx::Error, response[:status][:description]
    else
      raise PayEx::Error, %{invalid response: #{response.inspect}}
    end
  end

  def invoke_raw! wsdl, name, body
    Savon.client(wsdl).request(name, body: body) {
      http.headers.delete('SOAPAction')
    }.body
  end
end

require 'payex/api/util'
require 'payex/api/pxorder'
