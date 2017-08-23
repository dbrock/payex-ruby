module PayEx
  extend self

  TEST_URL = 'https://test-external.payex.com'
  LIVE_URL = 'https://external.payex.com'

  attr_accessor :base_url

  self.base_url = PayEx::TEST_URL

  attr_accessor :account_number
  attr_accessor :encryption_key
  attr_accessor :default_currency

  def account_number!
    account_number or fail 'Please set PayEx.account_number'
  end

  def encryption_key!
    encryption_key or fail 'Please set PayEx.encryption_key'
  end

  def default_currency!
    default_currency or fail 'Please set PayEx.default_currency'
  end
end

class PayEx::Error < StandardError; end
class PayEx::Error::CardDeclined < PayEx::Error; end

require 'payex/api'
require 'payex/api/pxorder'
require 'payex/redirect'
