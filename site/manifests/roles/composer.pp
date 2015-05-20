# Mailcatcher
class site::roles::composer {

  class { '::composer':
    auto_update => 'true',
  }

}
