# Everything needed to set up a basic web server
class site::roles::webserver {

  anchor { '::site::roles::webserver': }

  Class {
    require => Anchor['::site::roles::webserver'],
  }

  # Create users
  file { '/var/www':
    ensure => 'directory',
  }

  file { '/var/www/.ssh':
    ensure => 'directory',
    group  => 'www-data',
    mode   => '0755',
    owner  => 'www-data',
    purge  => true,
  }

  class { 'nginx': }

  nginx::resource::vhost { 'nwea':
    ensure      => present,
    listen_port => 8888,
    www_root    => '/var/www/nwea',
    require     => Vcsrepo['/var/www/nwea'],
  }

  vcsrepo { '/var/www/nwea':
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/nwea-techops/tech_quiz.git',
  }

  firewall { '102 allow http':
    dport  => [80],
    proto  => tcp,
    action => accept,
  }

  firewall { '103 allow https':
    dport  => [443],
    proto  => tcp,
    action => accept,
  }

  # www-data compliance script
  file { '/root/comply.sh':
    path    => '/root/comply.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/comply.sh.erb'), # we're using a template here for consistency; but it's not needed
  }

}
