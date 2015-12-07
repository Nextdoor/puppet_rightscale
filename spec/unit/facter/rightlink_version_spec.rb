require 'spec_helper'
require 'facter/is_rightscale'
require 'facter/rightlink_version'

describe Facter::Util::Fact do

  #
  # RightLink version testing
  #
  describe "rightlink_version" do

    before do
      Facter.clear
      Facter.clear_messages
      allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
      allow(Facter.fact(:is_rightscale)).to receive(:value).and_return(true)
      allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return(nil)
      allow(Facter::Util::Resolution).to receive(:exec).with('rightlink --version').and_return(nil)
    end
    
    after do
      Facter.clear
      Facter.clear_messages
    end
    
    context "RightLink6 is installed" do
      it "should return String '6.0.0'" do
        allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return("rs_config 6.0.0")
        expect(Facter.fact(:rightlink_version).value).to eq('6.0.0')
      end
    end
    
    context "RightLink10 is installed" do
      it "should return String '10.0.0'" do
        allow(Facter::Util::Resolution).to receive(:exec).with('rightlink --version').and_return("rightlink 10.0.0")
        expect(Facter.fact(:rightlink_version).value).to eq('10.0.0')
      end
    end
    
    context "RightLink is not installed" do
      it "should return the nil value" do
        allow(Facter.fact(:is_rightscale)).to receive(:value).and_return(false)
        expect(Facter.fact(:rightlink_version).value).to eq(nil)
      end
    end
    
  end
end
