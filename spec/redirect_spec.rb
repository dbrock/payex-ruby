# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'
require 'savon/mock/spec_helper'

describe PayEx::Redirect do
  include Savon::SpecHelper

  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  SAMPLE_ACCOUNT_NUMBER = 'SAMPLEACCOUNTNUMBER0001'
  SAMPLE_ENCRYPTION_KEY = 'SAMPLEENCRYPTIONKEY0001'
  SAMPLE_DEFAULT_CURRENCY = 'SEK'

  before {
    PayEx.account_number = SAMPLE_ACCOUNT_NUMBER
    PayEx.encryption_key = SAMPLE_ENCRYPTION_KEY
    PayEx.default_currency = SAMPLE_DEFAULT_CURRENCY
  }

  SAMPLE_PRICE_CENTS = 12300
  SAMPLE_ORDER_ID = 'SAMPLEORDERID0001'
  SAMPLE_PRODUCT_NUMBER = 'SAMPLEPRODUCTNUMBER0001'
  SAMPLE_PRODUCT_DESCRIPTION = 'Sample product description 0001'
  SAMPLE_IP_ADDRESS = '12.34.56.78'
  SAMPLE_RETURN_URL = 'http://example.com/payex-return'
  SAMPLE_CANCEL_URL = 'http://example.com/payex-cancel'

  describe :initialize! do
    example 'successful initialization' do
      expected = {
        'accountNumber' => SAMPLE_ACCOUNT_NUMBER,
        'purchaseOperation' => 'AUTHORIZATION',
        'price' => SAMPLE_PRICE_CENTS,
        'priceArgList' => '',
        'currency' => SAMPLE_DEFAULT_CURRENCY,
        'vat' => 0,
        'orderID' => SAMPLE_ORDER_ID,
        'productNumber' => SAMPLE_PRODUCT_NUMBER,
        'description' => SAMPLE_PRODUCT_DESCRIPTION,
        'clientIPAddress' => SAMPLE_IP_ADDRESS,
        'clientIdentifier' => '',
        'additionalValues' => 'RESPONSIVE=1',
        'externalID' => '',
        'returnUrl' => SAMPLE_RETURN_URL,
        'view' => 'CREDITCARD',
        'agreementRef' => '',
        'cancelUrl' => SAMPLE_CANCEL_URL,
        'clientLanguage' => ''
      }
      expected['hash'] = PayEx::API.signed_hash(expected.values.join)

      initialize_ok_fixture = File.read('spec/fixtures/initialize8/initialize_ok.xml')
      savon.expects(:initialize8).with(message: expected).returns(initialize_ok_fixture)

      href = PayEx::Redirect.initialize!(
        purchase_operation: 'AUTHORIZATION',
        price: SAMPLE_PRICE_CENTS,
        order_id: SAMPLE_ORDER_ID,
        product_number: SAMPLE_PRODUCT_NUMBER,
        description: SAMPLE_PRODUCT_DESCRIPTION,
        client_ip_address: SAMPLE_IP_ADDRESS,
        return_url: SAMPLE_RETURN_URL,
        cancel_url: SAMPLE_CANCEL_URL
      )
      href.should include 'http'
    end
  end

  SAMPLE_ORDER_REF = 'SAMPLEORDERREF0001'

  describe :complete! do
    def invoke_complete! response_fixture_file
      expected = {
        'accountNumber' => SAMPLE_ACCOUNT_NUMBER,
        'orderRef' => SAMPLE_ORDER_REF
      }

      expected['hash'] = PayEx::API.signed_hash(expected.values.join)
      response_fixture = File.read("spec/fixtures/complete/#{response_fixture_file}.xml")
      savon.expects(:complete).with(message: expected).returns(response_fixture)
      PayEx::Redirect.complete! SAMPLE_ORDER_REF
    end

    example 'successful completion' do
      order_id, error, data = invoke_complete! :complete_ok
      order_id.should == SAMPLE_ORDER_ID
      error.should == nil
    end

    example 'unexpected failure' do
      order_id, error, data = invoke_complete! :complete_failed
      order_id.should == SAMPLE_ORDER_ID
      error.should be_a PayEx::Error
    end

    example 'card declined' do
      order_id, error, data = invoke_complete! :complete_declined
      order_id.should == SAMPLE_ORDER_ID
      error.should be_a PayEx::Error
      error.should be_a PayEx::Error::CardDeclined
    end
  end
end
