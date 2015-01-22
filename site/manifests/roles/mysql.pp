# Wrap mysql to ensure that the mysql client is installed first
# Mysql server installation will fail if the server is set up first
class site::roles::mysql {
  anchor { '::site::roles::mysql': }
  class { '::site::roles::mysql::client': }

  Class {
    require => Anchor['::site::roles::mysql'],
  }

}
