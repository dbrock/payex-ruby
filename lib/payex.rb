module PayEx
  extend self

  TEST_URL = 'https://test-external.payex.com'
  LIVE_URL = 'https://external.payex.com'

  class Error < StandardError; end

  attr_accessor :default_currency
  attr_accessor :base_url

  attr_accessor :account_number
  attr_accessor :encryption_key

  attr_accessor :return_url
  attr_accessor :cancel_url
end

PayEx.default_currency = 'SEK'
PayEx.base_url = PayEx::TEST_URL

require 'payex/api'
require 'payex/pxorder'

def PayEx.account_number!
  PayEx.account_number or fail 'Please set PayEx.account_number'
end

def PayEx.encryption_key!
  PayEx.encryption_key or fail 'Please set PayEx.encryption_key'
end

def PayEx.authorize_transaction! order_id, params
  response = PayEx::PxOrder.Initialize7 \
    orderID: order_id,
    purchaseOperation: 'AUTHORIZATION',
    productNumber: params[:product_number],
    description: params[:product_description],
    price: params[:price],
    clientIPAddress: params[:customer_ip],
    returnUrl: PayEx.return_url,
    cancelUrl: PayEx.cancel_url

  response[:redirect_url]
end

def PayEx.complete_transaction! id
  response = PayEx::PxOrder.Complete(orderRef: id)

  status = response[:transaction_status]
  status = PayEx.parse_transaction_status(status)

  case status
  when :sale, :authorize
    response[:order_id]
  when :initialize
    raise PayEx::Error, 'Transaction not completed'
  when :failure
    message = response[:error_details][:third_party_error] rescue nil
    raise PayEx::Error, message
  else
    raise PayEx::Error, 'Unexpected transaction status: ' +
      status.to_s.upcase
  end
end

def PayEx.parse_transaction_status(status)
  case status.to_s
  when '0' then :sale
  when '1' then :initialize
  when '2' then :credit
  when '3' then :authorize
  when '4' then :cancel
  when '5' then :failure
  when '6' then :capture
  else status.to_s
  end
end
