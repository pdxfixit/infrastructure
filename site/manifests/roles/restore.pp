class site::roles::restore (
  $databases = lookup('databases', {}),
  $vcsrepos  = lookup('vcsrepos', {}),
) {

  #######
  # Files
  #######

  # restore each of the file repos
  # This may break if there's not a matching vhost
  $vcsrepos.each |$k, $v| {
    vcsrepo { $k:
      ensure   => present,
      path     => $v['path'],
      provider => 'git',
      source   => $v['source'],
      before   => Class['::apache']
    }

    # Database config file
    if $databases["${k}_db"] {
      file_line { "${k}_config_host":
        ensure => present,
        path   => "${v['path']}/configuration.php",
        line   => "\tpublic \$host = '${databases["${k}_db"]['host']}';",
        match  => 'public \$host \= \'',
      }

      file_line { "${k}_config_user":
        ensure => present,
        path   => "${v['path']}/configuration.php",
        line   => "\tpublic \$user = '${databases["${k}_db"]['user']}';",
        match  => 'public \$user \= \'',
      }

      file_line { "${k}_config_pass":
        ensure => present,
        path   => "${v['path']}/configuration.php",
        line   => "\tpublic \$password = '${databases["${k}_db"]['password']}';",
        match  => 'public \$password \= \'',
      }

      file_line { "${k}_config_db":
        ensure => present,
        path   => "${v['path']}/configuration.php",
        line   => "\tpublic \$db = '${k}_db';",
        match  => 'public \$db \= \'',
      }
    }
  }

  ###########
  # Databases
  ###########

  # get database backups
  vcsrepo { 'database_backups':
    ensure   => present,
    path     => '/var/db',
    provider => 'git',
    source   => 'https://bitbucket.org/pdxfixit/database-backups.git',
  }

  # create the databases
  create_resources('mysql::db', $databases, {
    'before' => Exec['restore_databases'],
  })

  # restore databases
  exec { 'restore_databases':
    command     => '/root/dbimport.sh',
    creates     => '/var/db/restore-complete',
    require     => [
      File['dbimport.sh'],
      Vcsrepo['database_backups'],
    ],
  }

}