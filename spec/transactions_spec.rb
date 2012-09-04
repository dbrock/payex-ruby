# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'

describe PayEx do
  describe '#initiate_transaction' do
    before {
      PayEx.account_number = 'foo-account'
      PayEx.encryption_key = 'foo-secret'
    }

    it 'should send request and parse response' do
      expected = {
        'accountNumber' => 'foo-account',
        'purchaseOperation' => 'AUTHORIZE',
        'price' => 12300,
        'currency' => 'SEK',
        'vat' => 0,
        'orderID' => 'order123',
        'productNumber' => 'PRODUCT123',
        'description' => 'Product description',
        'clientIPAddress' => '12.34.56.78',
        'returnUrl' => 'http://example.com/payex-callback',
        'view' => 'CREDITCARD'
      }

      expected['hash'] = PayEx::API::Util.signed_hash(expected.values.join)
      savon.expects('Initialize8').with(expected).returns(:initialize_ok)

      transaction = PayEx.initiate_transaction! \
        order_id: 'order123',
        ip: '12.34.56.78',
        product_id: 'PRODUCT123',
        description: 'Product description',
        price: 12300,
        callback: 'http://example.com/payex-callback'

      transaction.should be_a PayEx::Transaction
      transaction.href.should include transaction.id
    end
  end
end
