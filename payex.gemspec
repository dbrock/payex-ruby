# -*- ruby; coding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = 'payex'
  gem.version = '0.2'
  gem.summary = 'PayEx SOAP API glue'
  gem.author = 'Daniel Brockman'
  gem.files = `git ls-files 2>/dev/null`.split($\)

  gem.add_dependency 'httpclient', '~> 2.2'
  gem.add_dependency 'nori', '~> 1.1'
  gem.add_dependency 'savon', '~> 1.1'

  gem.add_development_dependency 'guard', '~> 1.3'
  gem.add_development_dependency 'guard-bundler', '~> 1.0'
  gem.add_development_dependency 'guard-rspec', '~> 1.2'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.11'
  gem.add_development_dependency 'savon_spec', '~> 1.3'
  gem.add_development_dependency 'terminal-notifier-guard', '~> 1.5'
end
