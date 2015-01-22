# Install the basic packages every system needs
class site::base::packages {

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      $basic_packages = [ 'wget', 'screen', 'nc', 'mtr', 'iotop', 'openssh-clients', 'git' ]
    }
    'Debian', 'Ubuntu': {
      $basic_packages = [ 'wget', 'screen', 'netcat6', 'mtr', 'iotop', 'openssh-client', 'git', 'zip', 'unzip', 'apt-file', 'acl', 'python-pip', 'jq', 'patch', 'python-dev', 'libxml2-dev', 'libxslt1-dev', 'libssl-dev' ]
    }
    default: {
      $basic_packages = [ 'wget', 'git', 'acl', 'python-pip', 'jq', 'patch', 'python-dev', 'libxml2-dev', 'libxslt1-dev', 'libssl-dev' ]
    }
  }

  include apt

  package { $basic_packages:
    ensure  => 'installed',
    require => Exec['apt_update'],
  }

}
