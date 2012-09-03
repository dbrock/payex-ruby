module PayEx
  TEST_URL = 'https://test-external.payex.com'
  LIVE_URL = 'https://external.payex.com'
end

class << PayEx
  attr_accessor :default_currency
  attr_accessor :account_number
  attr_accessor :encryption_key
  attr_accessor :base_url
end

PayEx.base_url = PayEx::TEST_URL
PayEx.default_currency = 'SEK'

require 'payex/pxorder'
