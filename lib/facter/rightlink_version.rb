Facter.add(:rightlink_version) do
  confine :kernel => %w{Linux Windows}
  setcode do

    rightlink_facter_debug = ENV.has_key?('RIGHTLINK_FACTER_DEBUG')
    
    version = nil
    matches = nil
    
    # check for RightLink < 10
    regex = %r{^rs_config (?<version>\d\.\d+\.\d+).*$}
    matches = regex.match(Facter::Util::Resolution.exec('rs_config --version'))
    puts "Match status for RightLink < 10: %s" % (matches) if rightlink_facter_debug
    if nil != matches and matches.names.include? 'version'
      version = matches['version']
      
    # check for RightLink == 10
    else
      regex = %r{^\w+ (?<version>\d+\.\d+\.\d+).*$}
      matches = regex.match(Facter::Util::Resolution.exec('rightlink --version'))
      puts "Match status for RightLink 10: %s" % (matches) if rightlink_facter_debug
      if nil != matches and matches.names.include? 'version'
        version = matches['version']
      end
    end

    if nil != version
      version.to_s
    else
      version
    end
    
  end
end

Facter.add(:rightlink_maj_version) do
  confine :kernel => %w{Linux Windows}
  setcode do

    rightlink_facter_debug = ENV.has_key?('RIGHTLINK_FACTER_DEBUG')

    rightlink_version = Facter.value(:rightlink_version)
    puts "rightlink_version: %s" % (rightlink_version) if rightlink_facter_debug
    
    majversion = nil

    if rightlink_version
      majversion = rightlink_version.split('.')[0]
    end

    if nil != majversion
      majversion.to_i
    else
      majversion
    end
    
  end
end
