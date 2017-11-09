require 'spec_helper'

describe '::rightscale', :type => 'class' do

  let(:pre_condition) { 'class { "apt": }' }

  let! :facts do
    {
      :osfamily                  => 'Debian',
      :operatingsystem           => 'Ubuntu',
      :operatingsystemmajrelease => '12.04',
      :lsbdistid                 => 'Ubuntu',
      :lsbdistcodename           => 'precise',
      :lsbdistrelease            => '12.04',
      :lsbmajdistrelease         => '12',
      :kernel                    => 'linux',
      :is_rightscale             => true,
    }
  end

  context 'default params and RightLink6' do
    it do
      facts.merge!(
        {
          :rightlink_version     => '6.0.0',
          :rightlink_maj_version => 6
        }
      )

      should compile.with_all_deps

      should contain_package('right_aws').with(
               'ensure' => '3.1.0')
      should contain_package('right_api_client').with(
               'ensure' => '1.5.26')

      should contain_class('sudo')
      should contain_sudo__conf('rightscale_users').with(
               'content' => /%rightscale_sudo\s+ALL=NOPASSWD\:\s+ALL/)
      should contain_sudo__conf('rightscale').with(
               'content' => /rightscale\s+ALL=\(ALL\)NOPASSWD/)
    end
  end

  context 'default params and RightLink10' do
    it do
      facts.merge!(
        {
          :rightlink_version     => '10.0.0',
          :rightlink_maj_version => 10
        }
      )

      should compile.with_all_deps
      should contain_class('sudo')
      should contain_sudo__conf('rightlink10_sudoers').with(
               'content' => /rightlink\s+ALL=\(ALL\)\s+SETENV:NOPASSWD\:ALL/)
    end
  end

  context 'RightLink6 manage_rightlink_sudo == false' do
    let(:params) { { :manage_rightlink_sudo => false } }
    it do
      facts.merge!(
        {
          :rightlink_version => '6.0.0',
          :rightlink_maj_version => 6
        }
      )

      should_not contain_class('sudo')
      should_not contain_sudo__conf('rightlink10_sudoers')
    end
  end

  context 'RightLink10 manage_rightlink_sudo == false' do
    let(:params) { { :manage_rightlink_sudo => false } }
    it do
      facts.merge!(
        {
          :rightlink_version => '10.0.0',
          :rightlink_maj_version => 10
        }
      )

      should_not contain_class('sudo')
      should_not contain_sudo__conf('rightscale_users')
      should_not contain_sudo__conf('rightscale')
    end
  end

  context 'CentOS and RightLink' do
    it do
      facts.merge!(
        {
          :operatingsystem       => 'CentOS',
          :is_rightscale         => true,
          :rightlink_version     => '6.0.0',
          :rightlink_maj_version => 6
        }
      )

      should compile.with_all_deps
      should contain_package('right_aws').with(
        'ensure' => '3.1.0')
      should contain_package('right_api_client').with(
        'ensure' => 'installed')
    end
  end

end
