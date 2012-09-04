require 'nori'
require 'savon'

module PayEx::API
  extend self

  class ParamError < StandardError; end

  def invoke! wsdl, name, params, specs
    client = Savon.client(wsdl)
    body = PayEx::API::Util.get_request_body(params, specs)
    response = client.request(name, body: body)
    Nori.parse(response.body)[:payex]
  end
end

require 'payex/api/util'
require 'payex/api/pxorder'
