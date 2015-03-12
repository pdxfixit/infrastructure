# Wrap mysql client class
class site::roles::mysql::client (
  $databases = hiera('databases'),
) {

  class { '::mysql::client':
    package_ensure => 'installed',
  }

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
