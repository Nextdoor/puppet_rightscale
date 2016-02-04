# == Class: rightscale::params
#
# Variables and versions for the RightScale class
#
# === Authors
#
# Matt Wise <matt@nextdoor.com>
#
class rightscale::params {

  # The rest-client gem/package is tricky. On older Ubuntu hosts, its safer to
  # just install the ruby-rest-client debian package, and then install the
  # right_api_client with "--ignore-dependencies". On newer Ubuntu hosts, the
  # Gem works fine .. but its not perfect.

  # Ubuntu 12.04 requires right_api_client <= 1.5.26 due to deps on
  # 'base64' module shipped with Ruby 1.8.7.

  if 'Ubuntu' == $::operatingsystem {
    $rest_provider = 'apt'
    $rest_package  = 'ruby-rest-client'

    if '12.04' == $::operatingsystemmajrelease {
      $right_api_client = '1.5.26'
    }
    
  } else {
    $rest_provider = 'gem'
    $rest_package = 'rest-client'  
    $right_api_client = 'installed'
  }
  
  $right_aws        = '3.1.0'
}
