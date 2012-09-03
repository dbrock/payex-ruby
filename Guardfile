# -*- ruby -*-

guard :bundler do
  watch 'Gemfile'
  watch 'payex.gemspec'
end

guard :rspec, cli: '--color', bundler: false do
  watch(%r'^(lib|spec)/') { 'spec' }
end
