# Wrap mysql to ensure that the mysql client is installed first
# Mysql server installation will fail if the server is set up first
class site::roles::mysql {
  anchor { '::site::roles::mysql': }
  class { '::site::roles::mysql::client': }

  Class {
    require => Anchor['::site::roles::mysql'],
  }

  include apt

  apt::source { 'mariadb':
    location => 'http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      id     => '199369E5404BD5FC7D2FE43BCBCB082A1BB943DB',
      server => 'hkp://keyserver.ubuntu.com:80',
    },
    include => {
      src   => false,
      deb   => true,
    },
  }

}
