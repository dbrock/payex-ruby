# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'

describe PayEx::PxOrder do
  describe 'Initialize8' do
    PayEx.encryption_key = 'foo'

    it 'should send request and parse response' do
      savon.expects('Initialize8').returns(:initialize_ok)
      response = PayEx::PxOrder.Initialize8 \
        price: 29900,
        orderID: 'XYZ123',
        productNumber: 'ABC123',
        description: 'iPad Mini',
        clientIPAddress: '99.99.99.99',
        returnUrl: 'http://example.com/payex-return'
      response[:status][:code].should == 'OK'
    end
  end
end
