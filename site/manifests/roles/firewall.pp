# Set firewall rules common to each environment
class site::roles::firewall {
  class { '::firewall': }
  resources { 'firewall':
    #purge => true
  }

  firewall { '100 allow ssh':
    dport  => [22],
    proto  => tcp,
    action => accept,
  }

  Firewall {
    before  => Class['site::firewall::post'],
    require => Class['site::firewall::pre'],
  }

  class { ['site::firewall::pre', 'site::firewall::post']: }
}
