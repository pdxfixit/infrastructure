# Install the basic packages every system needs
class site::base::r10k (
  $dir        = '/etc/puppet', # Should be /etc/puppet/environments/<env>
  $puppetfile = '/pdxfixit/infra/Puppetfile', # normally /etc/puppet/Puppetfile
){

  case $::lsbdistcodename {
    'precise': { $ruby = 'rubygems' }
    default: { $ruby = 'ruby' }
  }

  package { [ $ruby, 'git' ]:
    ensure => 'installed',
  }

  package { 'r10k':
    ensure   => 'installed',
    provider => 'gem',
    require  => Package[$ruby],
  }

  # Run r10k
  exec { 'run r10k':
    command     => "r10k --verbose info puppetfile install",
    cwd         => $dir,
    environment => ['HOME=/root',"PUPPETFILE=${puppetfile}"],
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    require     => [ Package['git'], Package['r10k'] ],
  }

}
