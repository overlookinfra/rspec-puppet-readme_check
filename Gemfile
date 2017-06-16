source ENV['GEM_SOURCE'] || "https://rubygems.org"

def location_for(place, fake_version = nil)
  if place =~ /^((?:git|https?)[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

gemspec

gem 'rspec-puppet', *location_for(ENV['RSPEC_GEM_VERSION'] || '~> 3.0')

if File.exist?('Gemfile.local')
  eval_gemfile('Gemfile.local')
end
