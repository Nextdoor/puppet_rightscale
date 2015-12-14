Facter.add(:is_rightscale) do
  confine :kernel => %w{Linux Windows}
  setcode do

    ret = false
    
    rs_config = Facter::Util::Resolution.exec('rs_config --version')
    rsc = Facter::Util::Resolution.exec('rsc --version')
    
    Facter.debug("is_rightscale :: rsconfig --version :: %s" % rs_config)
    Facter.debug("is_rightscale :: rsc --version :: %s" % rsc)

    if rsc or rs_config
      ret = true
    end
    
    Facter.debug("is_rightscale :: ret: %s" % ret)
    ret
  end
end
