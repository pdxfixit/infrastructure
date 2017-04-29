# Configure puppet.conf as part of bootstrapping puppet
class site::base::puppetconf (
  $environment = 'dev',
  $modulepath  = "./modules:\$basemodulepath:/pdxfixit/infra",
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
  }

}
