require 'spec_helper'

require "#{File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'puppet', 'type', 'rs_tag')}"
require "#{File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'lib', 'puppet', 'provider', 'rs_tag', 'rsc')}"

provider_class = Puppet::Type.type(:rs_tag).provider(:rsc)

describe provider_class do

  ##
  ## Start of tests
  ##
  context "on RightLink 10" do

    let(:resource) { Puppet::Type.type(:rs_tag).new(
      { :name     => 'test', :provider => described_class.name } )}
    let(:provider) { resource.provider }

    before :each do
      ##
      ## Set up lots of convenience vars, mocks, etc
      ##
      Facter.stubs(:value).with(:is_rightscale).returns(true)
      Facter.stubs(:value).with(:rightlink_version).returns('10.0.0')
      Facter.stubs(:value).with(:rightlink_maj_version).returns(10)

      @rightlink_self_href = '/api/clouds/6/instances/DEADBEEF'
      Facter.stubs(:value).with(:rightlink_self_href).returns(@rightlink_self_href)

      # convenient mocks for the commands executed by Provider
      @mock_tag_query_cmd = :rsc
      @mock_tag_query_params = %W(--rl10 cm15 by_resource /api/tags/by_resource
                             resource_hrefs[]=#{@rightlink_self_href})
      @mock_tag_add_params = %W(--rl10 cm15 multi_add /api/tags/multi_add
                           resource_hrefs[]=#{@rightlink_self_href} tags[]=test)
      @mock_tag_remove_params = %W(--rl10 cm15 multi_delete /api/tags/multi_delete
                              resource_hrefs[]=#{@rightlink_self_href} tags[]=test)

      Puppet::Util.stubs(:which).with(@mock_tag_query_cmd).returns('/usr/local/bin/rsc')

      # Mocked list of existing tags to run our tests against
      existing_tags =
        '[{"actions":[], "links":[], ' + \
        '"tags":[{"name":"test_tag_1"}, {"name":"test_tag:with_predicate=1"}]}]'
      provider.class.stubs(@mock_tag_query_cmd).with(@mock_tag_query_params).returns(existing_tags)
    end

    let(:instance) { provider.class.instances.first }

    describe 'self.prefetch' do
      it 'exists' do
        provider.class.instances
        provider.class.prefetch({})
      end

      it 'should work with rs_tag failure' do
        provider.class.stubs(@mock_tag_query_cmd).with(
          @mock_tag_query_params).raises(Puppet::ExecutionFailure, "Error")
        expect(provider.class.instances).to eq nil
        expect(provider.class.prefetch({})).to eq nil
      end
    end

    describe 'exists?' do
      it 'checks if `test` tag exists (should not)' do
        expect(provider.exists?).to be_falsey
      end
    end

    describe 'self.instances' do
      it 'returns an array of tags' do
        instances = provider.class.instances.collect {|x| x.name }
        expect(['test_tag_1', 'test_tag:with_predicate']).to match_array(instances)
      end
    end
    
    describe 'self.get_tags' do
      it 'should return a list of providers' do
        providers = provider.class.get_tags()
        expect(providers.length).to eq 2
      end
    end

    describe 'self.get_tags() with no tags set' do
      it 'should return an empty array' do
        existing_tags =
          '[{"actions":[], "links":[], "tags":[]}]'
        provider.class.stubs(@mock_tag_query_cmd).with(@mock_tag_query_params).returns(existing_tags)
        providers = provider.class.get_tags()
        expect(providers.length).to eq 0
      end
    end

    describe 'self.get_tags() with failed rsc output' do
      it 'should return nil' do
        existing_tags = 'bogus output'
        provider.class.stubs(@mock_tag_query_cmd).with(@mock_tag_query_params).returns(existing_tags)
        providers = provider.class.get_tags()
        expect(providers).to eq nil
      end
    end

    describe 'create' do
      it 'should allow creation of the tag `test`' do
        provider.class.expects(@mock_tag_query_cmd).with(@mock_tag_add_params)
        provider.create
      end
    end

    describe 'destroy' do
      it 'should allow removal of the tag `test`' do
        provider.class.expects(@mock_tag_query_cmd).with(@mock_tag_remove_params)
        
        provider.destroy
      end
    end
  end
end
