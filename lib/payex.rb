module PayEx
  extend self

  TEST_URL = 'https://test-external.payex.com'
  LIVE_URL = 'https://external.payex.com'

  class Error < StandardError; end

  attr_accessor :default_currency
  attr_accessor :base_url

  attr_accessor :account_number
  attr_accessor :encryption_key
end

PayEx.base_url = PayEx::TEST_URL

require 'payex/api'
require 'payex/pxorder'
require 'payex/credit_card_redirect'

def PayEx.account_number!
  PayEx.account_number or fail 'Please set PayEx.account_number'
end

def PayEx.encryption_key!
  PayEx.encryption_key or fail 'Please set PayEx.encryption_key'
end
