# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'

describe PayEx do
  before {
    PayEx.account_number = 'foo-account'
    PayEx.encryption_key = 'foo-secret'
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

    transaction = PayEx.initialize_transaction! \
      order_id: 'order123',
      ip: '12.34.56.78',
      product_id: 'PRODUCT123',
      description: 'Product description',
      price: 12300,
      callback: 'http://example.com/payex-callback'

    transaction[:href].should include transaction[:id]
  end
end
