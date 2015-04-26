# Jenkins
class site::roles::jenkins {

  class { '::jenkins':
    configure_firewall => true,
    lts                => true,
  }

}
