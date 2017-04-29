# XDebug for PHP
class site::roles::webserver::xdebug {

  php::module { 'xdebug':
    provider =>'pecl',
  }

  # TODO: We really need to do a `find / -name 'xdebug.so'` and put the output below...
  $xdebug = 'zend_extension="/usr/lib/php5/20090626/xdebug.so"
xdebug.remote_connect_back=1
xdebug.remote_enable=1
xdebug.remote_host=127.0.0.1
xdebug.remote_port=9000'

  file { 'xdebug.ini':
    path    => '/etc/php5/apache2/conf.d/xdebug.ini',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $xdebug,
  }

}
