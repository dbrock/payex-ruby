# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'

describe PayEx do
  before {
    PayEx.account_number = 'foo-account'
    PayEx.encryption_key = 'foo-secret'
    PayEx.return_url = 'http://example.com/payex-callback'
  }

  it 'should send request and parse response' do
    expected = {
      'accountNumber' => 'foo-account',
      'purchaseOperation' => 'AUTHORIZATION',
      'price' => 12300,
      'priceArgList' => '',
      'currency' => 'SEK',
      'vat' => 0,
      'orderID' => 'order123',
      'productNumber' => 'PRODUCT123',
      'description' => 'Product description',
      'clientIPAddress' => '12.34.56.78',
      'clientIdentifier' => '',
      'additionalValues' => '',
      'externalID' => '',
      'returnUrl' => 'http://example.com/payex-callback',
      'view' => 'CREDITCARD',
      'agreementRef' => '',
      'cancelUrl' => '',
      'clientLanguage' => ''
    }

    expected['hash'] = PayEx::API::Util.signed_hash(expected.values.join)
    savon.expects('Initialize7').with(expected).returns(:initialize_ok)

    href = PayEx.authorize_transaction! 'order123',
      product_number: 'PRODUCT123',
      product_description: 'Product description',
      price: 12300,
      customer_ip: '12.34.56.78'

    href.should include 'http'
  end
end
