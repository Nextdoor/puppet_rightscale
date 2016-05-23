# Fact: rightlink_self_href
#
# Offer value which would reside in RS_SELF_HREF during a RightScript run
# as a Facter fact.
#
# Values: nil or the self href
#
# Notes:
#
# Author: Nathan Valentine - <nrvale0@gmail.com|nathan@nextdoor.com>
#
Facter.add(:rightlink_self_href) do
  confine :kernel => %w{Linux Windows}
  confine :is_rightscale => [true, 'true']
  confine :rightlink_maj_version => 10

  setcode do
    rightlink_self_href = nil

    rightlink_maj_version = Facter.value(:rightlink_maj_version)
    Facter.debug("rightlink_self_href:: detected RightLink version #{rightlink_maj_version}...")

    case rightlink_maj_version
    when 10, '10'
      rightlink_self_href = Facter::Util::Resolution.exec("rsc --rl10 cm15 --x1 ':has(.rel:val(\"self\")).href'"\
                                                          " index_instance_session /api/sessions/instance")
      Facter.debug("rightlink_self_href:: captured value from rsc: #{rightlink_self_href}")
    when 6, '6'
      Facter.debug("rightlink_self_href:: Detected RightLink 6; doing nothing.")
    else
      Facter.debug("rightlink_self_href:: Detected unsupported rightlink_maj_version: #{rightlink_maj_version}.")
    end

    rightlink_self_href
  end
end
