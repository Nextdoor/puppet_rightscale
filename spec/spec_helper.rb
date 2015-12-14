require 'rubygems'
#require 'simplecov'
#require 'simplecov-csv'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet-lint'

# Configure the coverage reporter
#SimpleCov.start do
#  add_filter '/spec/'
#end
#SimpleCov.refuse_coverage_drop
#SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
#  SimpleCov::Formatter::HTMLFormatter,
#  SimpleCov::Formatter::CSVFormatter,
#]

# TODO(mwise): Figure out how to exceute this only in Ruby 1.9+,
# it fails in Ruby 1.8.7.
#SimpleCov.at_exit do
#  SimpleCov.result.format!
#end

# need this for allow()
RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

if ENV['RSPEC_PUPPET_DEBUG']
  Puppet::Util::Log.level = :debug
  Puppet::Util::Log.newdestination(:console)
end
