require 'spec_helper'
require 'facter/rightlink_version'

describe Facter::Util::Fact do
  
  before do
    Facter.clear
    Facter.clear_messages
    allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
  end

  after do
    Facter.clear
    Facter.clear_messages
  end

  #
  # RightLink version testing
  #
  describe "rightlink_version" do
    
    context "RightLink is not installed" do
      it "should return the nil value" do
        expect(Facter.fact(:rightlink_version).value).to eq(nil)
      end
    end
    
    context "RightLink6 is installed" do
      before do
        allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return("rs_config 6.0.0")
      end
      
      it "should return String '6.0.0'" do
        expect(Facter.fact(:rightlink_version).value).to eq('6.0.0')
      end
    end
    
    context "RightLink10 is installed" do
      before do
        allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return(nil)
        allow(Facter::Util::Resolution).to receive(:exec).with('rightlink --version').and_return("rightlink 10.0.0")
      end
      
      it "should return String '10.0.0'" do
        expect(Facter.fact(:rightlink_version).value).to eq('10.0.0')
      end
    end
  end

  #
  # RightLink major version Fact testing
  #
  describe "rightlink_maj_version" do

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
