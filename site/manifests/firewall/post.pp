# A drop all rule needs to be added to the end of firewall rules
# This is preferred to using a default DROP policy because it's harder
# to lock yourself out this way
class site::firewall::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
