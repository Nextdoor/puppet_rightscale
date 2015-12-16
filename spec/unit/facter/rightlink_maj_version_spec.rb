require 'spec_helper'
require 'facter/rightlink_version'
require 'facter/rightlink_maj_version'

describe Facter::Util::Fact do
  
  #
  # RightLink major version Fact testing  #
  describe "rightlink_maj_version" do
    
    before do
      Facter.clear
      Facter.clear_messages
      allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
    end
    
    after do
      Facter.clear
      Facter.clear_messages
    end
    
    context "Fact 'rightlink_version' does not exist" do
      it "should return value nil" do
        allow(Facter.fact(:rightlink_version)).to receive(:value).and_return(nil)
        expect(Facter.fact(:rightlink_maj_version).value).to eq(nil)
      end
    end
  
    context "Fact 'rightlink_version' exists" do
      it "should return the Integer 10 if 'rightlink_version' is '10.0.0'" do
        allow(Facter.fact(:rightlink_version)).to receive(:value).and_return('10.0.0')
        expect(Facter.fact(:rightlink_maj_version).value).to eq(10)
      end
    end
  end
end
