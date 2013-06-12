SPEC_ROOT = File.dirname(__FILE__).freeze

require "rspec"
require "cf"
require "cfoundry"
require "cfoundry/test_support"
require "webmock/rspec"
require "cf/test_support"
require "blue-shell"

require "#{SPEC_ROOT}/../lib/admin-cf-plugin/plugin"

RSpec.configure do |c|
  c.include FakeHomeDir
  c.include CliHelper
  c.include InteractHelper
  c.include BlueShell::Matchers
end
