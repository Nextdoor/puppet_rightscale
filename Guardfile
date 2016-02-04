guard 'remote-sync',
      :ssh => true,
      :source => 'lib/',
      :destination => '/var/lib/puppet/lib',
      :user => 'root',
      :delete => false,
      :recursive => true,
      :verbose => true,
      :progress => true,
      :sync_on_start => true,
      :dry_run => false,
      :timeout => 10,
      :remote_address => ENV['RIGHTSCALE_NODE'] do

  watch(%r{^.+$})
  
end
