# Set default firewall
# Purge existing firewall rules, then set order to ensure correct
# beginning and end rules are specified (pre / post)
class site::firewall::default {
  resources { 'firewall':
    purge => true
  }

  Firewall {
    before  => Class['site::firewall::post'],
    require => Class['site::firewall::pre'],
  }

  class { ['site::firewall::pre', 'site::firewall::post']: }
}
