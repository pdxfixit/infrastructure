# Wrap mysql client class
class site::roles::mysql::client (
  $databases = hiera('databases', {}),
) {

  include site::roles::mysql

  class {'::mysql::client':
    package_name    => 'mariadb-client',
    install_options => '--allow-unauthenticated', # dear god why
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
