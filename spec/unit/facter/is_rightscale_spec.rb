require 'spec_helper'
require 'facter/is_rightscale'

describe Facter::Util::Fact do

  #
  # Are we running in context of RightScale?
  #
  describe "is_rightscale" do

    before do
      Facter.clear
      Facter.clear_messages
      allow(Facter.fact(:kernel)).to receive(:value).and_return("Linux")
      allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return(nil)
      allow(Facter::Util::Resolution).to receive(:exec).with('rsc --version').and_return(nil)
    end
    
    after do
      Facter.clear
      Facter.clear_messages
    end

    context "RightScale rs_config binary exists" do
      it "should return true" do
        allow(Facter::Util::Resolution).to receive(:exec).with('rs_config --version').and_return("rs_config 6.0.0")
        expect(Facter.fact(:is_rightscale).value).to eq true
      end
    end

    context "RightScale rsc binary exists" do
      it "should return true" do
        allow(Facter::Util::Resolution).to receive(:exec).with('rsc --version').and_return("rightlink 10.0.0")
        expect(Facter.fact(:is_rightscale).value).to eq true
      end
    end

    context "Neither rsc nor rs_config binaries exist"do
      it "should return false" do
        expect(Facter.fact(:is_rightscale).value).to eq false
      end
    end
  end
end
