Facter.add(:rightlink_version) do
  confine :kernel => %w{Linux Windows}
  confine :is_rightscale => [true, 'true']
  setcode do

    version = nil
    matches = nil

    # check for RightLink == 10
    regex = %r{^\w+ (?<version>\d+\.\d+\.\d+).*$}
    matches = regex.match(Facter::Util::Resolution.exec('rightlink --version'))
    Facter.debug("Match status for RightLink 10: %s" % (matches))
    if nil != matches and matches.names.include? 'version'
      version = matches['version']
    else
      
      # check for RightLink < 10
      regex = %r{^rs_config (?<version>\d\.\d+\.\d+).*$}
      matches = regex.match(Facter::Util::Resolution.exec('rs_config --version'))
      Facter.debug("Match status for RightLink < 10: %s" % (matches))
      if nil != matches and matches.names.include? 'version'
        version = matches['version']
      end
    end

    unless nil == version
      version = version.to_s
    end
    
    version
    
  end
end
