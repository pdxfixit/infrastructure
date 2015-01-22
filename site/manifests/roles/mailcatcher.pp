# Mailcatcher
class site::roles::mailcatcher (
  $http_ip   = '0.0.0.0',
  $http_port = '1080',
  $smtp_ip   = '0.0.0.0',
  $smtp_port = '1025',
) {

  class { '::mailcatcher':
    http_ip        => $http_ip,
    http_port      => $http_port,
    service_enable => 'true',
    smtp_ip        => $smtp_ip,
    smtp_port      => $smtp_port,
  }

  firewall { '110 allow mailcatcher':
    port   => [$http_port],
    proto  => tcp,
    action => accept,
  }

}
