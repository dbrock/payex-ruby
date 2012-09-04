# -*- coding: utf-8 -*-
require 'payex'
require 'spec_helper'

describe PayEx::API do
  before {
    PayEx.encryption_key = 'foo'
  }

  it 'should know how to stringify keys' do
    PayEx::API.stringify_keys(a: 1, b: 2).
      should == { 'a' => 1, 'b' => 2 }
  end

  it 'should know how to sign params' do
    param_hash, specs, param_array = {}, {}, []

    for name in 'a'..'z'
      if rand < 0.5
        param_hash[name] = rand
        param_array << param_hash[name]
        specs[name] = { signed: true }
      else
        param_hash[name] = rand
      end
    end

    actual = PayEx::API.sign_params(param_hash, specs)

    to_sign = param_array.join + PayEx.encryption_key
    expected = Digest::MD5.hexdigest(to_sign)

    actual.should == expected
  end

  it 'should know how to add defaults' do
    PayEx::API.parse_param(nil, { default: 2 }).should == 2
  end

  it 'should know how to call default procs' do
    PayEx::API.parse_param(nil, { default: proc { 2 } }).should == 2
  end

  it 'should reject wrong type of value' do
    proc {
      PayEx::API.parse_param('foobar', { format: Integer })
    }.should raise_error PayEx::API::ParamError
  end

  it 'should reject strings based on regular expressions' do
    proc {
      PayEx::API.parse_param('foobar', { format: /^.{,3}$/ })
    }.should raise_error PayEx::API::ParamError
  end

  it 'should stringify keys when parsing params' do
    PayEx::API.parse_params({ a: 1 }, { 'b' => { default: 2 } }).
      should == { 'a' => 1, 'b' => 2 }
  end
end
