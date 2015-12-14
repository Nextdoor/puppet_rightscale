Facter.add(:rightlink_version) do
  confine :kernel => %w{Linux Windows}
  confine :is_rightscale => [true, 'true']
  
  setcode do
    version = nil
    out = nil

    # check for RightLink == 10
    # regex = %r{^\w+ (?<version>\d+\.\d+\.\d+).*$}
    regex = "^\w+ \d+\.\d+\.\d+.*$"
    out = Facter::Util::Resolution.exec('rightlink --version')
    Facter.debug("rightlink_version :: Match status for RightLink 10: %s" % (out.to_s))
    unless nil != out
      # check for RightLink < 10
      # regex = %r{^rs_config (?<version>\d\.\d+\.\d+).*$}
      regex = "^rs_config \d+\.\d+\.\d+.*$"
      out = Facter::Util::Resolution.exec('rs_config --version')
      Facter.debug("rightlink_version :: Match status for RightLink < 10: %s" % (out.to_s))
    end

    unless nil == out
      version = out.split(' ')[1]
      Facter.debug("rightlink_version :: version: %s" % (version))
    end

    version
    
  end
end
