require 'savon_spec'

Savon::Spec::Fixture.path =
  File.expand_path('../fixtures', __FILE__)

RSpec.configure do |config|
  config.include Savon::Spec::Macros
end
