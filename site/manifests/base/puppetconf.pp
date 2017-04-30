# Configure puppet.conf as part of bootstrapping puppet
class site::base::puppetconf (
  $datadir     = '/pdxfixit/infra',
  $environment = 'dev',
  $modulepath  = "./modules:\$basemodulepath:$datadir",
){

  ini_setting {
    'modulepath':
      ensure  => present,
      path    => "/etc/puppetlabs/code/environments/$environment/environment.conf",
      setting => 'modulepath',
      section => 'main',
      value   => $modulepath;
    'environment':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      setting => 'environment',
      section => 'main',
      value   => $environment;
    'warnings':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      setting => 'disable_warnings',
      section => 'main',
      value   => [
        'deprecations',
        'undefined_resources',
        'undefined_variables',
      ];
  }

  file { "/etc/puppetlabs/code/environments/$environment/hieradata":
    ensure => link,
    target => $datadir,
  }

}
