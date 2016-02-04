source "https://rubygems.org"

if '1.8.7' == RUBY_VERSION or '1.9.3' == RUBY_VERSION or '2.0.0' == RUBY_VERSION
  rspec_core_version = '3.1.7'
  listen_version = '1.3.1'
  rest_client_version = '1.6.8'
  logging_version = '1.8.2'
else
  rspec_core_version = '>= 3.4.1'
  listen_version = '>= 3.0.5'
  rest_client_version = '>= 1.8.0'
  logging_version = '>= 2.0.0'
end

# Required for unit testing
gem 'facter', :require => false, :group => :test
gem 'puppet', '3.7.4', :require => false, :group => :test
gem 'puppet-lint', :require => false, :group => :test
gem 'puppetlabs_spec_helper', :require => false, :group => :test
gem 'rake', :require => false, :group => :test
gem 'rest-client', rest_client_version, :require => false, :group => :test
gem 'listen', listen_version, :require => false, :group => :test
gem 'rspec-core', rspec_core_version, :require => false, :group => :test
gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git', :require => false, :group => :test
gem 'rspec-hiera-puppet', :require => false, :group => :test
gem 'rspec-mocks', :require => false, :group => :test
gem 'simplecov', :require => false, :group => :test
gem 'simplecov-summary', :require => false, :group => :test
gem 'simplecov-csv', :require => false, :group => :test
gem 'puppet-syntax', :require => false, :group => :test
gem 'guard-remote-sync', :require => false, :group => :test

# Required for the module itself
gem 'parseconfig'
gem 'logging', logging_version
gem 'mime-types', '<= 1.25.1'
gem 'right_api_client', '>= 1.5.16'
