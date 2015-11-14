Facter.add(:rightlink_version) do
  confine :kernel => %w{Linux Windows}
  setcode do

    RIGHTLINK_VERSION_DEBUG = ENV.has_key?('RIGHTLINK_VERSION_DEBUG')
    
    version = nil
    matches = nil
    
    # check for RightLink < 10
    regex = %r{^rs_config (?<version>\d\.\d+\.\d+).*$}
    matches = regex.match(Facter::Util::Resolution.exec('rs_config --version'))
    puts "Match status for RightLink < 10: %s" % (matches) if RIGHTLINK_VERSION_DEBUG
    if nil != matches and matches.names.include? 'version'
      version = matches['version']
      
    # check for RightLink == 10
    else
      regex = %r{^\w+ (?<version>\d+\.\d+\.\d+).*$}
      matches = regex.match(Facter::Util::Resolution.exec('rightlink --version'))
      puts "Match status for RightLink 10: %s" % (matches) if RIGHTLINK_VERSION_DEBUG
      if nil != matches and matches.names.include? 'version'
        version = matches['version']
      end
    end
    
    version
    
  end
end
