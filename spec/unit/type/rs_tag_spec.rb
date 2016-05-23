require 'spec_helper'
require "#{File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'puppet', 'type', 'rs_tag')}"

#supported_rightlink_versions = %w(6 10)
supported_rightlink_versions = %w(10)

describe Puppet::Type.type(:rs_tag) do
  supported_rightlink_versions.each do |rightlink_maj_version|
    rightlink_maj_version = rightlink_maj_version.to_i
    describe "on RightLink version #{rightlink_maj_version}" do

      # mock up an underlying provider to be used by a few of the tests
      before :each do
        @provider_class = described_class.provide(:test_provider) do
          mk_resource_methods
          def self.instances; []; end
        end
        described_class.stubs(:defaultprovider).returns @provider_class
      end

      case rightlink_maj_version
      when 6
        let!(:facts) {{
                        :is_rightscale => true,
                        :rightlink_version => '6.0.0',
                        :rightlink_maj_version => 6 }}
      when 10
        let!(:facts) {{
                       :is_rightscale => true,
                       :rightlink_version => '10.0.0',
                       :rightlink_maj_version => 10 }}
      else
        raise Exception, "Unsupported RightLink version: #{rightlink_maj_version}"
      end
      
      let :tag do
        Puppet::Type.type(:rs_tag).new(
          :name  => 'test')
      end

      it 'name => test' do
        tag[:name] = 'test'
        tag[:name].should == 'test'
      end

      it 'name => $!@ should fail' do
        lambda { tag[:name] = '$!@' }.should raise_error(Puppet::Error)
      end

      it 'name => BadTagName should fail' do
        lambda { tag[:name] = 'BadTagName' }.should raise_error(Puppet::Error)
      end

      it 'name => missing_predicate: should fail' do
        lambda { tag[:name] = 'missing_predicate:' }.should raise_error(Puppet::Error)
      end

      it 'name => name:predicate, value => nil should fail' do
        lambda {
          Puppet::Type.type(:rs_tag).new(
            :name  => 'name:predicate')
        }.should raise_error(Puppet::Error)
      end

      it 'name => name_without_predicate, value => foobar should fail' do
        lambda {
          Puppet::Type.type(:rs_tag).new(
            :name  => 'name_without_predicate',
            :value => 'foobar')
        }.should raise_error(Puppet::Error)
      end

      it 'name => name:predicate, value => something' do
        Puppet::Type.type(:rs_tag).new(
          :name  => 'name:predicate',
          :value => 'something')
      end

      it 'value => test' do
        tag[:value] = 'test'
        tag[:value].should == 'test'
      end
    end
  end
end
