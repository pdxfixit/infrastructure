# Configure puppet.conf as part of bootstrapping puppet
class site::base::puppetconf (
  $environment = 'dev',
  $modulepath  = '$confdir/environments/$environment/modules:$confdir/environments/$environment/:/pdxfixit/infra:$confdir',
){

  ini_setting {
    'modulepath':
      ensure  => present,
      path    => '/etc/puppet/puppet.conf',
      setting => 'modulepath',
      section => 'main',
      value   => $modulepath;
    'environment':
      ensure  => present,
      path    => '/etc/puppet/puppet.conf',
      setting => 'environment',
      section => 'main',
      value   => $environment;
    'templatedir':
      ensure  => absent,
      path    => '/etc/puppet/puppet.conf',
      setting => 'templatedir',
      section => 'main';
  }

}
