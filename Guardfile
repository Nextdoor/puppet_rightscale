guard 'remote-sync',
      :ssh => true,
      :source => 'lib/facter',
      :destination => "/tmp",
      :user => 'root',
      :remote_address => ENV['RIGHTLINK10_NODE'] do

  watch(%r{^.+\.(pp|rb)$})
  
end
