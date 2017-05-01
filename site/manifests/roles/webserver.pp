# Everything needed to set up a basic web server
class site::roles::webserver (
  $vhosts = {},
) {

  anchor { '::site::roles::webserver': }

  # Create vhosts
  create_resources('apache::vhost', $vhosts)

  # Create users
  file { '/var/www':
    ensure => directory,
  }

  file { '/var/www/.ssh':
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
    purge  => true,
  }

  # create /var/www/<domain>
  $vhosts.each |$k, $v| {
    file { "/var/www/${v['servername']}":
      ensure => directory,
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
      before => Apache::Vhost[$k], # vhost resource will create /var/www/<domain>/www
    }
  }

  # users { 'basic': }

  class { 'apache':
    default_confd_files => false,
    default_mods        => false,
    default_vhost       => false,
    mpm_module          => 'prefork',
    service_name        => 'apache2',
  }

  class { '::site::roles::webserver::php': }

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

  include apache::mod::autoindex
  include apache::mod::deflate
  include apache::mod::rewrite
  include apache::mod::ssl
  include apache::mod::status

  # www-data compliance script
  file { '/root/comply.sh':
    path    => '/root/comply.sh',
    owner   => 'root',
    group   => 'root',
    mode    => '0775',
    content => template('site/comply.sh.erb'), # we're using a template here for consistency; but it's not needed
  }

}
