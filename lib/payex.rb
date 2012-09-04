module PayEx
  TEST_URL = 'https://test-external.payex.com'
  LIVE_URL = 'https://external.payex.com'

  class Error < StandardError; end

  class << self
    attr_accessor :default_currency
    attr_accessor :base_url
    attr_accessor :account_number
    attr_accessor :encryption_key
    attr_accessor :return_url
    attr_accessor :cancel_url
  end
end

require 'payex/api'
require 'payex/transactions'

PayEx.default_currency = 'SEK'
PayEx.base_url = PayEx::TEST_URL

def PayEx.account_number!
  PayEx.account_number or fail 'Please set PayEx.account_number'
end

def PayEx.encryption_key!
  PayEx.encryption_key or fail 'Please set PayEx.encryption_key'
end
