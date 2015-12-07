Facter.add(:is_rightscale) do
  confine :kernel => %w{Linux Windows}
  setcode do

    ret = false
    
    rs_config = Facter::Util::Resolution.exec('rs_config --version')
    rsc = Facter::Util::Resolution.exec('rsc --version')
    
    Facter.debug("rsconfig --version :: %s" % rs_config)
    Facter.debug("rsc --version :: %s" % rsc)

    if rsc or rs_config
      ret = true
    end
    
    Facter.debug("ret: %s" % ret)
    ret
  end
end
