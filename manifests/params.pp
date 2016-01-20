# == Class: rightscale::params
#
# Variables and versions for the RightScale class
#
# === Authors
#
# Matt Wise <matt@nextdoor.com>
#
class rightscale::params {
  # TODO: When supporting other OS's, will update this class with a big case
  # statement. For now, this supports Ubuntu 10/12 with Ruby 1.8.
  $right_api_client = '1.5.19'
  $right_aws        = '3.1.0'

  # The rest-client gem/package is tricky. On older Ubuntu hosts, its safer to
  # just install the ruby-rest-client debian package, and then install the
  # right_api_client with "--ignore-dependencies". On newer Ubuntu hosts, the
  # Gem works fine .. but its not perfect.
  #
  # To handle this more sanely, on non-Ubunth hosts, we'll ue the Gem for now.
  # On Ubuntu hosts, we'll use the ruby-rest-client package.
  case $::operatingsystem {
    'Ubuntu': {
      $rest_provider = 'apt'
      $rest_package  = 'ruby-rest-client'
      $rest_client   = '1.6.7-1'
    }
    default: {
      $rest_provider = 'gem'
      $rest_package  = 'rest-client'
      $rest_client   = '1.6.7-1'
    }
  }
}
