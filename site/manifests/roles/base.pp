# The base role is for basic configuration common to all servers
# Wraps other packages to avoid having to redefine these for each node
class site::roles::base (
  $timezone = 'America/Los_Angeles',
  ) {

  anchor { '::site::roles::base': }

  Class {
    require => Anchor['::site::roles::base'],
  }

  include ruby
  include ruby::dev

  class { '::site::base::packages': }
  class { '::site::roles::firewall': }
  class { '::ntp': }
  class { 'timezone':
    timezone => $timezone
  }

  # Munin
  class { 'munin':
    monitor      => true,
    monitor_tool => [ 'munin' ],
  }

}
