require 'spec_helper'
require 'facter/is_rightscale'
require 'facter/rightlink_version'
require 'facter/rightlink_maj_version'

describe Facter::Util::Fact do
  
  describe "rightlink_self_href" do

    before do
      Facter.clear
      Facter.clear_messages
      allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
      allow(Facter.fact(:is_rightscale)).to receive(:value).and_return(true)
    end

    after do
      Facter.clear
      Facter.clear_messages
    end

    context "RightLink 6 is installed" do
      it "it should return nil" do
        allow(Facter.fact(:rightlink_version)).to receive(:value).and_return('6.0.0')
        allow(Facter.fact(:rightlink_maj_version)).to receive(:value).and_return(6)
        expect(Facter.fact(:rightlink_self_href).value).to eq nil
      end
    end

    context "RightLink 10 is installed" do
      it "should return a valid self href" do
        allow(Facter.fact(:rightlink_version)).to receive(:value).and_return('10.0.0')
        allow(Facter.fact(:rightlink_maj_version)).to receive(:value).and_return(10)
        allow(Facter::Util::Resolution).to receive(:exec).with(
                                             "rsc --rl10 cm15 --x1 ':has(.rel:val(\"self\")).href'"\
                                             " index_instance_session /api/sessions/instance"
                                           ).and_return('api/clouds/6/instances/DEADBEEF')
        expect(Facter.fact(:rightlink_self_href).value).to eq 'api/clouds/6/instances/DEADBEEF'
      end
    end
    
  end
  
end
