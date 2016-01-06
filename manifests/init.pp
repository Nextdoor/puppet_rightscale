# == Class: rightscale
#
# Sets up default settings for a RightScale managed host
#
# === Optional Parameters
#
# [*right_api_client*]
#   rightscale_api_client Gem version to install
#
# [*right_aws*]
#   right_aws Gem version to install
#
# [*rest_client*]
#   Supporting rest_client Gem Version to Install
#
# === Authors
#
# Matt Wise <matt@nextdoor.com>
#
class rightscale (
  $right_api_client = $rightscale::params::right_api_client,
  $right_aws        = $rightscale::params::right_aws,
  $rest_client      = $rightscale::params::rest_client,
  $rest_package     = $rightscale::params::rest_package,
  $rest_provider    = $rightscale::params::rest_provider,
  ) inherits ::rightscale::params {

  # pretty sure our version of stdlib does not include validate_integer
  # validate_integer($::rightlink_maj_version, 6, 10)
  validate_re("${::rightlink_maj_version}", '^(6|10)$')
  unless is_integer($::rightlink_maj_version) {
    fail("\$::rightlink_maj_version is \'${::rightlink_maj_version}\' but must be Integer!")
  }
  
  case $::rightlink_maj_version {
    10: { include ::sudo }
    
    6: {
      # Install the required gems in order. These gems support the custom
      # Hiera backend as well as the puppet rs-facts plugin that gathers
      # common RightScale facts.

      package {
        $rest_package:
          ensure   => $rest_client,
          provider => $rest_provider;
        
        'right_aws':
          ensure   => $right_aws,
          provider => 'gem',
          require  => Package[$rest_package];
        
        'right_api_client':
          ensure          => $right_api_client,
          provider        => 'gem',
          install_options => '--ignore-dependencies',
          require         => Package[$rest_package];
      }
    }
    
    default: {
      fail("RightLink ${::rightlink_maj_version} is not supported by this module!")
    }
  }
}
