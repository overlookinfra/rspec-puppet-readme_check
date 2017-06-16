# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'rbconfig'

ruby_conf = defined?(RbConfig) ? RbConfig::CONFIG : Config::CONFIG
less_than_one_nine = ruby_conf['MAJOR'].to_i == 1 && ruby_conf['MINOR'].to_i < 9

Gem::Specification.new do |s|
  s.name        = "rspec-puppet-readme_check"
  s.version     = "0.1.0"
  s.authors     = ["Puppet"]
  s.email       = ["modules@puppet.com"]
  s.homepage    = "https://github.com/puppetlabs/rspec-puppet-readme_check"
  s.summary     = %q{RSpec helper for readme format checking}
  s.description = %q{RSpec helper for readme format checking, see https://rspec-puppet.com}
  s.license     = 'Apache-2.0'


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Testing dependencies
  s.add_development_dependency 'minitest', '~> 5.4'
  s.add_development_dependency 'fakefs', '~> 0.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov' unless less_than_one_nine

  # Documentation dependencies
  s.add_development_dependency 'yard'
  s.add_development_dependency 'markdown' unless less_than_one_nine
  s.add_development_dependency 'thin'

  # Run time dependencies
  s.add_runtime_dependency 'rspec-puppet'
  s.add_runtime_dependency 'redcarpet', '~> 3.0'
end
