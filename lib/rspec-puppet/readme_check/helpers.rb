module RSpec::Puppet::ReadmeCheck::Helpers
  require 'rspec-puppet/readme_check/helpers/markdown'
  def markdown(*args)
    RSpec::Puppet::ReadmeCheck::Helpers::Markdown.new(*args)
  end
end

