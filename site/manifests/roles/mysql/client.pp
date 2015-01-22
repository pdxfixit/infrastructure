# Wrap mysql client class
class site::roles::mysql::client (
  $databases = hiera('databases')
) {

  class { '::mysql::client':
    package_ensure => 'installed',
  }

#  file { 'db.sh':
#    content => template('site/db.sh.erb'),
#    group   => 'root',
#    mode    => '0775',
#    owner   => 'root',
#    path    => '/root/db.sh',
#  }

  file { 'dbdump.sh':
    content => template('site/dbdump.sh.erb'),
    group   => 'root',
    mode    => '0775',
    owner   => 'root',
    path    => '/root/dbdump.sh',
  }

}
