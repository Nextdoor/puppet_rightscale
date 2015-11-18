require 'spec_helper'

# Facts mocked up for unit testing
FACTS = {
  :osfamily => 'Debian',
  :operatingsystem => 'Ubuntu',
  :operatingsystemrelease => '12',
  :lsbdistid => 'Ubuntu',
  :lsbdistcodename => 'precise',
  :lsbdistrelease => '12.04',
  :lsbmajdistrelease => '12',
  :kernel => 'linux',
  :is_rightscale => true,
}

describe 'rightscale', :type => 'class' do
  context 'default params for RightLink6' do
    let(:facts) { FACTS }
    let(:facts) { {:rightlink_version => '6.0.0'} }
    
    it do
      should compile.with_all_deps
      should contain_package('rest-client').with(
        'ensure' => '1.6.7')
      should contain_package('right_aws').with(
        'ensure' => '3.1.0')
      should contain_package('right_api_client').with(
        'ensure' => '1.5.19')
    end
  end

  context 'default params for RightLink10' do
    let(:facts) { FACTS }
    let(:facts) { {:rightlink_version => '10.0.0'} }
    
    it do
      should compile.with_all_deps
      should contain_sudoers__add('includedir for RightLink10')
    end
  end
end
