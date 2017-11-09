# Fact: rightlink_maj_version
#
# Split rightlink_version to extract the major version.
#
# Values: Integer or nil.
#
# Notes: Requires Fact rightlink_version.
#
# Author: Nathan Valentine - <nathan@nextdoor.com|nrvale0@gmail.com>
#
Facter.add(:rightlink_maj_version) do
  confine :kernel => %w{Linux Windows}

  setcode do

    rightlink_version = Facter.value(:rightlink_version)
    Facter.debug("rightlink_maj_version :: rightlink_version: %s" % (rightlink_version))
    
    majversion = nil

    if rightlink_version
      majversion = rightlink_version.split('.')[0]
    end

    unless nil == majversion
      majversion = majversion.to_i
    end

    majversion
    
  end
end
