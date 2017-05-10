# The base role is for basic configuration common to all servers
# Wraps other packages to avoid having to redefine these for each node
class site::roles::base (
  $timezone = 'America/Los_Angeles',
) {

  include ruby
  include ruby::dev

  class { '::site::base::packages': }
  class { '::site::roles::firewall': }
  class { '::ntp': }
  class { 'timezone': timezone => $timezone }

  create_resources('ssh_authorized_key', lookup('ssh_authorized_keys', {}))

}
