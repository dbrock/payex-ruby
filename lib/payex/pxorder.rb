require 'payex/soap'

module PayEx::PxOrder
  extend PayEx::SOAPEndpoint
  wsdl '%s/pxorder/pxorder.asmx?WSDL' % PayEx.base_url
  require 'payex/pxorder/initialize'
  require 'payex/pxorder/complete'
end
