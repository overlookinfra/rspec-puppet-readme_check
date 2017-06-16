module RSpec::Puppet::ReadmeCheck::Helpers
  require 'rspec-puppet/readme_check/helpers/readme'
  def readme(*args)
    RSpec::Puppet::ReadmeCheck::Helpers::Readme.new(*args)
  end
end

