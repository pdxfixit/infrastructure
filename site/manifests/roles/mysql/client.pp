# Wrap mysql client class
class site::roles::mysql::client (
  $databases = hiera('databases', {}),
) {

  include site::roles::mysql

  class {'::mysql::client':
    package_name    => 'mariadb-client',
    package_ensure  => "10.1.19+maria-1~${::lsbdistcodename}",
    bindings_enable => true,
  }

  Apt::Source['mariadb'] ~>
  Class['apt::update'] ->
  Class['::mysql::client']

  file { 'dbimport.sh':
    content => template('site/dbimport.sh.erb'),
    group   => 'root',
    mode    => '0770',
    owner   => 'root',
    path    => '/root/dbimport.sh',
  }

  file { 'dbexport.sh':
    content => template('site/dbexport.sh.erb'),
    group   => 'root',
    mode    => '0770',
    owner   => 'root',
    path    => '/root/dbexport.sh',
  }

}
