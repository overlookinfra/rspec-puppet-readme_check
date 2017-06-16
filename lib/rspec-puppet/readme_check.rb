require 'redcarpet'
require 'rspec-puppet/readme_check/render'
require 'rspec-puppet/readme_check/matchers'
require 'rspec-puppet/readme_check/helpers'
extend RSpec::Puppet::ReadmeCheck::Helpers
class RSpec::Core::ExampleGroup
  extend RSpec::Puppet::ReadmeCheck::Helpers
  include RSpec::Puppet::ReadmeCheck::Helpers
end
