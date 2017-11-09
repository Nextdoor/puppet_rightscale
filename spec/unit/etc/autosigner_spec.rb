require 'spec_helper'
require 'logging'
require 'openssl'
require 'tempfile'
require File.join(File.dirname(__FILE__), '../../../lib/etc/autosign.rb')

# Enable rspec-mock
RSpec.configure do |config|
  config.mock_framework = :rspec
end

Logging.logger.root.appenders = nil
#Logging.logger.root.appenders = Logging.appenders.stdout
#Logging.logger.root.level = :error

describe AutoSigner do
  before :each do
    # Load up some good and bad CSR examples
    @good_csr = OpenSSL::X509::Request.new(
      File.read(File.join(File.dirname(__FILE__), '../../fixtures/good.csr')))
    @bad_csr = OpenSSL::X509::Request.new(
      File.read(File.join(File.dirname(__FILE__), '../../fixtures/bad.csr')))

    # Mock the RightApi::Client to respond with a mocked object
    configs = {
      'global' => { 'challenge_password' => 'password',
                    'tag'                => 'mytag',
                    'debug'              => nil }
    }
    @mocked_client = double("RightScale")
    allow(@mocked_client).to receive(:new) { @mocked_client }
    allow(@mocked_client).to receive(:get_config) { configs }
    stub_const("RightScale", @mocked_client)
    @auto = AutoSigner.new()
  end

  it "#new" do
    # Lastly create our AutoSigner object
    expect(@auto).to be_an_instance_of AutoSigner
  end

  it "#new with debug enabled" do
    # Generate a temp log file
    file = Tempfile.new('log')

    configs = {
      'global' => { 'challenge_password' => 'bad_password',
                    'tag'                => 'mytag',
                    'debug'              => file.path }
    }
    allow(@mocked_client).to receive(:get_config) { configs }
    @auto = AutoSigner.new()
    @auto.should be_an_instance_of AutoSigner

    # Cleanup
    file.unlink()
  end

  ###############################
  # find_attribute() tests #
  ###############################
  it "find_attribute() should work" do
    @auto.find_attribute(
            'pp_preshared_key',
            @bad_csr.attributes).should == nil
    @auto.find_attribute(
            'challengePassword',
            @good_csr.attributes).should == 'password'
    @auto.find_attribute(
            'pp_preshared_key',
            @good_csr.attributes).should == 'key'
  end

  ########################
  # validate_csr() tests #
  ########################
  it "validate_csr() should work" do
    expect { @auto.validate_csr(@bad_csr) }.to raise_error(/invalid/)
    expected_response = ["password", "key"]
    @auto.validate_csr(@good_csr).should == expected_response
  end

  it "validate_csr() with valid csr, but bad password" do
    configs = {
      'global' => { 'challenge_password' => 'bad_password',
                    'tag'                => 'mytag',
                    'debug'              => nil }
    }
    allow(@mocked_client).to receive(:get_config) { configs }
    @auto = AutoSigner.new()
    expect { @auto.validate_csr(@good_csr) }.to raise_error(/invalid/)
  end

  ####################
  # validate() tests #
  ####################
  it "validate() should work" do
    # Mock out the validate_csr() call
    fake_validate_csr_return = [ 'password', 'key' ]
    @auto.stub(:validate_csr) { fake_validate_csr_return }

    # Mock out the @rs.get_tags_by_tag() call to return a single tag
    # that matches the tag in our good_csr fixture.
    fake_tags = [ 'mytag=key' ]
    @mocked_client.stub(:get_tags_by_tag) { fake_tags }
    @auto.validate('good_csr', @good_csr).should == true

    # Mock out the @rs.get_tags_by_tag() call to return a single tag
    # that does NOT match the supplied tag. Should raise exception.
    fake_tags = [ 'bad=key' ]
    @mocked_client.stub(:get_tags_by_tag) { fake_tags }
    expect {@auto.validate('good_csr', @good_csr)}.to raise_error(/Incorrect tag/)

    # Mock out the @rs.get_tags_by_tag() call to return multiple copies
    # of the same tag. Should raise an exception.
    fake_tags = [ 'mytag=key', 'mytag=key' ]
    @mocked_client.stub(:get_tags_by_tag) { fake_tags }
    expect {@auto.validate('good_csr', @good_csr)}.to raise_error(/Either/)

    # Mock out the @rs.get_tags_by_tag() call to return no tags!
    fake_tags = [ ]
    @mocked_client.stub(:get_tags_by_tag) { fake_tags }
    expect {@auto.validate('good_csr', @good_csr)}.to raise_error(/Either/)
  end
end
