# Configure hiera
# this is in a separate class so that it can be run during provisioning
# prior to the first full puppet run
# File precedence is as it appears below
class site::base::hiera::install (
  $datadir = '/root/pdxfixit-infra',
){

  class { 'hiera':
    hierarchy => [
      '%{environment}',
      'node/%{::fqdn}',
      'defaults',
    ],
    datadir => $datadir,
  }

}
