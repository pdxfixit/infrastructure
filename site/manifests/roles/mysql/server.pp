# Set up a mysql server instance
class site::roles::mysql::server (
  $buffer_pool_size = '128M',
  $databases        = hiera('databases', {}),
  $query_cache_size = '64M',
  $root_pwd         = hiera('mysql::server::root_password', 'password'),
  $tmp_table_size   = '64M',
) {

  class { '::mysql::client':
    package_ensure => 'installed',
  }

  file { 'dbimport.sh':
    path    => '/root/dbimport.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0770',
    content => template('site/dbimport.sh.erb'),
  }

  file { 'dbexport.sh':
    path    => '/root/dbexport.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0770',
    content => template('site/dbexport.sh.erb'),
  }

  firewall { '101 allow mysql inbound':
    dport  => [3306],
    proto  => tcp,
    action => accept,
  }

  create_resources('mysql::db', $databases)

  class { '::mysql::server':
    root_password    => $root_password,
    restart          => True,
    service_name     => 'mysql',
    override_options => { 'mysqld' => {
      'max_connections'                 => '1024',
      'max_connections'                 => '1024',
      'innodb_buffer_pool_size'         => $buffer_pool_size,
      'innodb_additional_mem_pool_size' => '20M',
      'bind_address'                    => '0.0.0.0',
      'tmp_table_size'                  => $tmp_table_size,
      'max_heap_table_size'             => '64M',
      'key_buffer_size'                 => '16M',
      'table_cache'                     => '2000',
      'thread_cache'                    => '20',
      'table_definition_cache'          => '4096',
      'table_open_cache'                => '1024',
      'query_cache_type'                => '1',
      'query_cache_size'                => $query_cache_size,
      'innodb_flush_method'             => 'O_DIRECT',
      'innodb_flush_log_at_trx_commit'  => '1',
      'innodb_file_per_table'           => '1',
      'long_query_time'                 => '5',
      'max-allowed-packet'              => '16M',
      'max-connect-errors'              => '1000000',
      }
    },
  }

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
