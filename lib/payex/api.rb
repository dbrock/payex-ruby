require 'nori'
require 'savon'

module PayEx::API
  extend self

  class ParamError < StandardError; end

  def invoke! wsdl, name, params, specs
    body = PayEx::API::Util.get_request_body(params, specs)
    response = Savon.client(wsdl).request(name, body: body) {
      http.headers.delete('SOAPAction')
    }.body
    # Unwrap <Initialize8Response>
    response = response[response.keys.first]
    # Unwrap <Initialize8Result>
    response = response[response.keys.first]
    # Embedded XML document contains result
    response = Nori.parse(response)
    # Unwrap <payex>
    response = response[response.keys.first]
  end
end

require 'payex/api/util'
require 'payex/api/pxorder'
