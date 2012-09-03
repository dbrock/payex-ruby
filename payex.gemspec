# -*- ruby; coding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = 'payex'
  gem.version = '0.0.0'
  gem.summary = 'PayEx SOAP API glue'
  gem.author = 'Daniel Brockman'
  gem.files = `git ls-files 2>/dev/null`.split($\)
  gem.add_dependency 'savon', '~> 1.1'
end
