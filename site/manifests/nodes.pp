node 'www', default {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::server': }
  class { '::site::roles::webserver': }
  class { '::site::roles::webserver::security': }
  if $environment == 'dev' {
    class { '::site::roles::mailcatcher': }
  }
}

node 'db', 'dbserver', /^db\d+$/ {
  class { '::site::roles::base': }
  class { '::site::roles::mysql::server': }
}
