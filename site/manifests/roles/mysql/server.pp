# Set up a mysql server instance
class site::roles::mysql::server (
  $buffer_pool_size = '128M',
  $databases        = hiera('databases', {}),
  $query_cache_size = '64M',
  $root_pwd         = hiera('mysql::server::root_password', 'password'),
  $tmp_table_size   = '64M',
) {

  include site::roles::mysql

  firewall { '101 allow mysql inbound':
    dport  => [3306],
    proto  => tcp,
    action => accept,
  }

  create_resources('mysql::db', $databases)

  class {'::mysql::server':
    package_name     => 'mariadb-server',
    install_options  => '--allow-unauthenticated', # dear god why
    service_name     => 'mysql',
    root_password    => $root_pwd,
    override_options => {
      mysqld => {
        'innodb_buffer_pool_size' => $buffer_pool_size,
        'log-error'               => '/var/log/mysql/mariadb.log',
        'pid-file'                => '/var/run/mysqld/mysqld.pid',
        'query_cache_size'        => $query_cache_size,
        'tmp_table_size'          => $tmp_table_size,
      },
      mysqld_safe => {
        'log-error' => '/var/log/mysql/mariadb.log',
      },
    },
    require          => Apt::Source['mariadb'],
  }

  Apt::Source['mariadb'] ~>
  Class['apt::update'] ->
  Class['::mysql::server']

  # Allow development access
  if $environment == 'dev' {
    mysql_user { 'root@192.168.47.1':
      ensure        => 'present',
      password_hash => mysql_password($root_pwd),
      require       => Class['::mysql::server'],
    }

    mysql_grant { 'root@192.168.47.1/*.*':
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL'],
      require    => Mysql_user['root@192.168.47.1'],
      table      => '*.*',
      user       => 'root@192.168.47.1',
    }
  }

  # This is the equivalent of running mysql_secure_installation
  class { '::mysql::server::account_security':
    require => Class['::mysql::server'],
  }

}
