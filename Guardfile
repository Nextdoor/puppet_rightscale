guard 'remote-sync',
      :ssh => true,
      :source => 'lib/facter',
      :destination => "/tmp",
      :user => 'root',
      :recursive => true,
      :verbose => true,
      :progress => true,
      :sync_on_start => true,
      :dry_run => false,
      :timeout => 10,
      :remote_address => ENV['RIGHTSCALE_NODE'] do

  watch(%r{^.+\.(pp|rb)$})
  
end
