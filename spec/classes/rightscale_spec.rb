require 'spec_helper'

describe '::rightscale', :type => 'class' do

  let! :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '12',
      :lsbdistid => 'Ubuntu',
      :lsbdistcodename => 'precise',
      :lsbdistrelease => '12.04',
      :lsbmajdistrelease => '12',
      :kernel => 'linux',
    }
  end
  
  context 'default params and RightLink6' do

    it do
      facts.merge!(
        {
          :is_rightscale => true,
          :rightlink_version => '6.0.0',
          :rightlink_maj_version => 6
        }
      )
      
      should compile.with_all_deps
      should contain_package('rest-client').with(
        'ensure' => '1.6.7')
      should contain_package('right_aws').with(
        'ensure' => '3.1.0')
      should contain_package('right_api_client').with(
        'ensure' => '1.5.19')
    end
  end

  context 'default params and RightLink10' do
    it do
      facts.merge!(
        {
          :is_rightscale => true,
          :rightlink_version => '10.0.0',
          :rightlink_maj_version => 10
        }
      )
      
      should compile.with_all_deps
      should contain_class('sudo')
    end
  end

end
