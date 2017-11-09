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
  :rightlink_version => '6.0.0',
  :rightlink_maj_version => 6
}

describe 'rightscale::repos', :type => 'class' do
  let(:pre_condition) { 'class { "apt": }' }

  context 'default params' do
    let(:facts) { FACTS }
    it { should compile }
    it { should contain_class('Apt::Update') }
    it { should contain_class('Apt::Params') }

    it { should contain_apt__key('6DCD2E1B55C68049DE9BFED362F960209A917D05').with(
      'source' => 'http://cf-mirror.rightscale.com/mirrorkeyring/rightscale_key.pub') }

    it { should contain_file('/etc/apt/sources.list.d/rightscale.sources.list').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'replace' => false,
      'content' => /http:\/\/cf-mirror.rightscale.com/,
      'notify'  => 'Class[Apt::Update]') }
    it { should contain_file('/etc/apt/sources.list.d/rightscale_extra.sources.list').with(
      'ensure'  => 'file',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'replace' => false,
      'content' => /http:\/\/cf-mirror.rightscale.com/,
      'notify'  => 'Class[Apt::Update]') }

    it { should_not contain_apt__source('rightscale_security_fallback') }
    it { should_not contain_apt__source('rightscale_security_mirror') }
  end

  context 'with force => true' do
    let(:facts) { FACTS }
    let(:params) { { 'force' => true } }

    it { should compile }
    it { should contain_file('/etc/apt/sources.list.d/rightscale.sources.list').with(
      'replace' => true) }
    it { should contain_file('/etc/apt/sources.list.d/rightscale_extra.sources.list').with(
      'replace' => true) }
  end

  context 'fallback_mirror => unittest.com' do
    let(:facts) { FACTS }
    let(:params) { { 'fallback_mirror' => 'unittest.com' } }

    it { should compile }
    it { should contain_apt__key('6DCD2E1B55C68049DE9BFED362F960209A917D05').with(
      'source' => 'http://unittest.com/mirrorkeyring/rightscale_key.pub') }
    it { should contain_file('/etc/apt/sources.list.d/rightscale.sources.list').with(
      'content' => /http:\/\/unittest.com/) }
    it { should contain_file('/etc/apt/sources.list.d/rightscale_extra.sources.list').with(
      'content' => /http:\/\/unittest.com/) }
  end

  context '$::rs_island => unittest.com' do
    my_facts = FACTS.clone
    my_facts[:rs_island] = 'unittest.com'
    let(:facts) { my_facts }

    it { should compile }
    it { should contain_file('/etc/apt/sources.list.d/rightscale.sources.list').with(
      'content' => /http:\/\/unittest.com/) }
    it { should contain_file('/etc/apt/sources.list.d/rightscale_extra.sources.list').with(
      'content' => /http:\/\/unittest.com/) }
  end

  context 'date => 1999/01/01' do
    let(:facts) { FACTS }
    let(:params) { { 'date' => '1999/01/01' } }

    it { should compile }
    it { should contain_file('/etc/apt/sources.list.d/rightscale.sources.list').with(
      'content' => /ubuntu_daily\/1999\/01\/01\//) }
    it { should contain_file('/etc/apt/sources.list.d/rightscale_extra.sources.list').with(
      'content' => /rightscale_software_ubuntu\/1999\/01\/01\//) }
  end

  context 'enable_security => latest' do
    let(:facts) { FACTS }
    let(:params) { { 'enable_security' => 'latest' } }

    it { should compile }
    it { should contain_apt__source('rightscale_security_fallback').with(
      'location' => 'http://cf-mirror.rightscale.com/ubuntu_daily/latest',
      'release'  => 'precise-security') }
    it { should_not contain_apt__source('rightscale_security_mirror') }
  end

  context 'enable_security => latest, fallback_mirror => unittest.com' do
    let(:facts) { FACTS }
    let(:params) { { 'enable_security' => 'latest',
                     'fallback_mirror' => 'unittest.com' } }

    it { should compile }
    it { should contain_apt__source('rightscale_security_fallback').with(
      'location' => 'http://unittest.com/ubuntu_daily/latest') }
    it { should_not contain_apt__source('rightscale_security_mirror') }
  end

  context 'enable_security => latest, $::rs_island => unittest.com' do
    my_facts = FACTS.clone
    my_facts[:rs_island] = 'unittest.com'
    let(:facts) { my_facts }
    let(:params) { { 'enable_security' => 'latest' } }

    it { should compile }
    it { should contain_apt__source('rightscale_security_mirror').with(
      'location' => 'http://unittest.com/ubuntu_daily/latest',
      'release'  => 'precise-security') }
  end
end
