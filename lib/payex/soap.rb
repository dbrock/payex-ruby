require 'savon'

module PayEx::SOAPEndpoint
  def wsdl(value=nil)
    @wsdl ||= value
  end

  def define_soap_method(name, param_options)
    (class << self; self end).__send__ :define_method, name do |params|
      PayEx::SOAPInvocation.new(wsdl, name, param_options, params).call
    end
  end

  def self.parse_param(value, options)
    if value.nil?
      if options.include? :default
        result = options[:default]
      else
        raise ArgumentError, 'parameter required'
      end
    else
      result = value
    end

    if options.include? :format
      unless options[:format] === result
        raise ArgumentError, '%s required' % options[:format].inspect
      end
    end

    result
  end
end

class PayEx::SOAPInvocation < Struct.new(:wsdl, :name, :param_options, :params)
  def call
    client = Savon.client(wsdl)
    client.request(name, body: body).to_hash
  end

  def body
    parsed_params.merge \
      'hash' => PayEx::SOAPInvocation.sign_params(params_to_sign)
  end

  def parsed_params
    params.dup.tap do |result|
      for key in params.keys
        if key.is_a? Symbol
          result.delete(key)
          result[key.to_s] = params[key]
        end
      end

      for name, options in param_options
        begin
          result[name] = PayEx::SOAPEndpoint.parse_param(result[name], options)
        rescue ArgumentError => error
          raise ArgumentError, '%s: %s' % [name.inspect, error.message]
        end
      end
    end
  end

  def params_to_sign
    [].tap do |result|
      # Hashes are sorted in Ruby 1.9
      for name, options in param_options
        if options[:signed?] or options[:signed]
          result << params[name]
        end
      end
    end
  end

  def self.sign_params(params)
    Digest::MD5.hexdigest(params.join + PayEx.encryption_key)
  end
end
