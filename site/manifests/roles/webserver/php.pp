# All site-specific PHP settings
# the many augeas settings were extracted from the rackspace configuration
class site::roles::webserver::php (
  $settings = hiera('php', {}),
) {

  validate_hash($settings)

  if has_key($settings, 'display_errors') {
    $display_errors = $settings[display_errors]
  } else {
    $display_errors = 'Off'
  }

  if has_key($settings, 'error_reporting') {
    $error_reporting = $settings[error_reporting]
  } else {
    $error_reporting = '0'
  }

  if has_key($settings, 'sendmail_path') {
    $sendmail_path = $settings[sendmail_path]
  } else {
    $sendmail_path = '/usr/sbin/sendmail -t -i'
  }

  if has_key($settings, 'smtp_host') {
    $smtp_host = $settings[smtp_host]
  } else {
    $smtp_host = 'localhost'
  }

  if has_key($settings, 'smtp_port') {
    $smtp_port = $settings[smtp_port]
  } else {
    $smtp_port = '25'
  }

  if $settings[use_apc] {
    $use_apc = $settings[use_apc]
  } else {
    $use_apc = false
  }

  include apache::mod::php

  class { '::php': }

  case $::lsbdistcodename { # Ubuntu 14.04 v 12.04 (default)
    'trusty': {
      exec { 'php5enmod-mcrypt':
        command => '/usr/sbin/php5enmod mcrypt && service apache2 reload',
        creates => '/etc/php5/apache2/conf.d/20-mcrypt.ini',
        require => Package[php5-mcrypt],
      }
    }
#    'precise', default: {
#    }
  }

  # Install PHP Modules
  php::module { 'mcrypt': }
  php::module { 'curl': }

  # CentOS and Ubuntu ship with different default PHP modules
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      php::module { 'pdo': }
      php::module { 'gd': }
      php::module { 'mbstring': }
      php::module { 'mysql': }
      php::module { 'xml': }
      if $use_apc {
        php::pecl::module { 'apc':
          use_package => false,
        }
      }
    }
    /^(Debian|Ubuntu)$/: {
      php::module { 'mysql': }
      php::module { 'gd': }
      package { 'libpcre3-dev': ensure => 'installed' }
      if $use_apc {
        php::pecl::module { 'apc':
          require     => Package[libpcre3-dev],
          use_package => false,
        }
      }
    }
    default: {
      php::module { 'mysql': }
      php::module { 'gd': }
    }
  }

  if $use_apc {
    php::augeas {
      'php-apc-enabled':
        entry => 'PHP/apc.enabled',
        value => '1';
    }

    php::augeas {
      'php-apc':
        entry => 'PHP/extension',
        value => 'apc.so';
    }
  }

  php::augeas {
    'php-allow_call_time_pass_reference':
      entry => 'PHP/allow_call_time_pass_reference',
      value => 'Off';
  }

  php::augeas {
    'php-allow_url_fopen':
      entry => 'PHP/allow_url_fopen',
      value => 'Off';
  }

  php::augeas {
    'php-allow_url_include':
      entry => 'PHP/allow_url_include',
      value => 'Off';
  }

  php::augeas {
    'php-asp_tags':
      entry => 'PHP/asp_tags',
      value => 'Off';
  }

  php::augeas {
    'php-auto_append_file':
      entry => 'PHP/auto_append_file',
      value => nil;
  }

  php::augeas {
    'php-auto_globals_jit':
      entry => 'PHP/auto_globals_jit',
      value => 'On';
  }

  php::augeas {
    'php-auto_prepend_file':
      entry => 'PHP/auto_prepend_file',
      value => nil;
  }

  php::augeas {
    'php-bcmath.scale':
      entry => 'PHP/bcmath.scale',
      value => '0';
  }

  php::augeas {
    'php-date.timezone':
      entry => 'PHP/date.timezone',
      value => 'America/Los_Angeles';
  }

  php::augeas {
    'php-default_mimetype':
      entry => 'PHP/default_mimetype',
      value => 'text/html';
  }

  php::augeas {
    'php-default_socket_timeout':
      entry => 'PHP/default_socket_timeout',
      value => '60';
  }

  php::augeas {
    'php-define_syslog_variables':
      entry => 'PHP/define_syslog_variables',
      value => 'Off';
  }

  php::augeas {
    'php-disable_classes':
      entry => 'PHP/disable_classes',
      value => nil;
  }

  php::augeas {
    'php-disable_functions':
      entry => 'PHP/disable_functions',
      value => nil;
  }

  php::augeas {
    'php-display_errors':
      entry => 'PHP/display_errors',
      value => $display_errors;
  }

  php::augeas {
    'php-display_startup_errors':
      entry => 'PHP/display_startup_errors',
      value => 'Off';
  }

  php::augeas {
    'php-doc_root':
      entry => 'PHP/doc_root',
      value => nil;
  }

  php::augeas {
    'php-enable_dl':
      entry => 'PHP/enable_dl',
      value => 'Off';
  }

  php::augeas {
    'php-engine':
      entry => 'PHP/engine',
      value => 'On';
  }

  php::augeas {
    'php-error_reporting':
      entry => 'PHP/error_reporting',
      value => $error_reporting;
  }

  php::augeas {
    'php-expose_php':
      entry => 'PHP/expose_php',
      value => 'Off';
  }

  php::augeas {
    'php-file_uploads':
      entry => 'PHP/file_uploads',
      value => 'On';
  }

  php::augeas {
    'php-html_errors':
      entry => 'PHP/html_errors',
      value => 'Off';
  }

  php::augeas {
    'php-ignore_repeated_errors':
      entry => 'PHP/ignore_repeated_errors',
      value => 'Off';
  }

  php::augeas {
    'php-ignore_repeated_source':
      entry => 'PHP/ignore_repeated_source',
      value => 'Off';
  }

  php::augeas {
    'php-implicit_flush':
      entry => 'PHP/implicit_flush',
      value => 'Off';
  }

  php::augeas {
    'php-log_errors_max_len':
      entry => 'PHP/log_errors_max_len',
      value => '1024';
  }

  php::augeas {
    'php-log_errors':
      entry => 'PHP/log_errors',
      value => 'On';
  }

  php::augeas {
    'php-magic_quotes_gpc':
      entry => 'PHP/magic_quotes_gpc',
      value => 'Off';
  }

  php::augeas {
    'php-magic_quotes_runtime':
      entry => 'PHP/magic_quotes_runtime',
      value => 'Off';
  }

  php::augeas {
    'php-magic_quotes_sybase':
      entry => 'PHP/magic_quotes_sybase',
      value => 'Off';
  }

  php::augeas {
    'php-mail.add_x_header':
      entry => 'PHP/mail.add_x_header',
      value => 'On';
  }

  php::augeas {
    'php-max_execution_time':
      entry => 'PHP/max_execution_time',
      value => '30';
  }

  php::augeas {
    'php-max_input_time':
      entry => 'PHP/max_input_time',
      value => '60';
  }

  php::augeas {
    'php-memory_limit':
      entry => 'PHP/memory_limit',
      value => '256M';
  }

  php::augeas {
    'php-mssql.allow_persistent':
      entry => 'PHP/mssql.allow_persistent',
      value => 'On';
  }

  php::augeas {
    'php-mssql.compatability_mode':
      entry => 'PHP/mssql.compatability_mode',
      value => 'Off';
  }

  php::augeas {
    'php-mssql.max_links':
      entry => 'PHP/mssql.max_links',
      value => '-1';
  }

  php::augeas {
    'php-mssql.max_persistent':
      entry => 'PHP/mssql.max_persistent',
      value => '-1';
  }

  php::augeas {
    'php-mssql.min_error_severity':
      entry => 'PHP/mssql.min_error_severity',
      value => '10';
  }

  php::augeas {
    'php-mssql.min_message_severity':
      entry => 'PHP/mssql.min_message_severity',
      value => '10';
  }

  php::augeas {
    'php-mssql.secure_connection':
      entry => 'PHP/mssql.secure_connection',
      value => 'Off';
  }

  php::augeas {
    'php-mysql.allow_persistent':
      entry => 'PHP/mysql.allow_persistent',
      value => 'Off';
  }

  php::augeas {
    'php-mysql.connect_timeout':
      entry => 'PHP/mysql.connect_timeout',
      value => '60';
  }

  php::augeas {
    'php-mysql.default_host':
      entry => 'PHP/mysql.default_host',
      value => nil;
  }

  php::augeas {
    'php-mysql.default_password':
      entry => 'PHP/mysql.default_password',
      value => nil;
  }

  php::augeas {
    'php-mysql.default_port':
      entry => 'PHP/mysql.default_port',
      value => nil;
  }

  php::augeas {
    'php-mysql.default_socket':
      entry => 'PHP/mysql.default_socket',
      value => nil;
  }

  php::augeas {
    'php-mysql.default_user':
      entry => 'PHP/mysql.default_user',
      value => nil;
  }

  php::augeas {
    'php-mysqli.default_host':
      entry => 'PHP/mysqli.default_host',
      value => nil;
  }

  php::augeas {
    'php-mysqli.default_port':
      entry => 'PHP/mysqli.default_port',
      value => '3306';
  }

  php::augeas {
    'php-mysqli.default_pw':
      entry => 'PHP/mysqli.default_pw',
      value => nil;
  }

  php::augeas {
    'php-mysqli.default_socket':
      entry => 'PHP/mysqli.default_socket',
      value => nil;
  }

  php::augeas {
    'php-mysqli.default_user':
      entry => 'PHP/mysqli.default_user',
      value => nil;
  }

  php::augeas {
    'php-mysqli.max_links':
      entry => 'PHP/mysqli.max_links',
      value => '-1';
  }

  php::augeas {
    'php-mysqli.reconnect':
      entry => 'PHP/mysqli.reconnect',
      value => 'Off';
  }

  php::augeas {
    'php-mysql.max_links':
      entry => 'PHP/mysql.max_links',
      value => '-1';
  }

  php::augeas {
    'php-mysql.max_persistent':
      entry => 'PHP/mysql.max_persistent',
      value => '-1';
  }

  php::augeas {
    'php-mysql.trace_mode':
      entry => 'PHP/mysql.trace_mode',
      value => 'Off';
  }

  php::augeas {
    'php-odbc.allow_persistent':
      entry => 'PHP/odbc.allow_persistent',
      value => 'On';
  }

  php::augeas {
    'php-odbc.check_persistent':
      entry => 'PHP/odbc.check_persistent',
      value => 'On';
  }

  php::augeas {
    'php-odbc.defaultbinmode':
      entry => 'PHP/odbc.defaultbinmode',
      value => '1';
  }

  php::augeas {
    'php-odbc.defaultlrl':
      entry => 'PHP/odbc.defaultlrl',
      value => '4096';
  }

  php::augeas {
    'php-odbc.max_links':
      entry => 'PHP/odbc.max_links',
      value => '-1';
  }

  php::augeas {
    'php-odbc.max_persistent':
      entry => 'PHP/odbc.max_persistent',
      value => '-1';
  }

  php::augeas {
    'php-output_buffering':
      entry => 'PHP/output_buffering',
      value => '0';
  }

  php::augeas {
    'php-pgsql.allow_persistent':
      entry => 'PHP/pgsql.allow_persistent',
      value => 'On';
  }

  php::augeas {
    'php-pgsql.auto_reset_persistent':
      entry => 'PHP/pgsql.auto_reset_persistent',
      value => 'Off';
  }

  php::augeas {
    'php-pgsql.ignore_notice':
      entry => 'PHP/pgsql.ignore_notice',
      value => '0';
  }

  php::augeas {
    'php-pgsql.log_notice':
      entry => 'PHP/pgsql.log_notice',
      value => '0';
  }

  php::augeas {
    'php-pgsql.max_links':
      entry => 'PHP/pgsql.max_links',
      value => '-1';
  }

  php::augeas {
    'php-pgsql.max_persistent':
      entry => 'PHP/pgsql.max_persistent',
      value => '-1';
  }

  php::augeas {
    'php-post_max_size':
      entry => 'PHP/post_max_size',
      value => '512M';
  }

  php::augeas {
    'php-precision':
      entry => 'PHP/precision',
      value => '14';
  }

  php::augeas {
    'php-register_argc_argv':
      entry => 'PHP/register_argc_argv',
      value => 'Off';
  }

  php::augeas {
    'php-register_globals':
      entry => 'PHP/register_globals',
      value => 'Off';
  }

  php::augeas {
    'php-register_long_arrays':
      entry => 'PHP/register_long_arrays',
      value => 'Off';
  }

  php::augeas {
    'php-report_memleaks':
      entry => 'PHP/report_memleaks',
      value => 'On';
  }

  php::augeas {
    'php-request_order':
      entry => 'PHP/request_order',
      value => 'GP';
  }

  php::augeas {
    'php-safe_mode_allowed_env_vars':
      entry => 'PHP/safe_mode_allowed_env_vars',
      value => 'PHP_';
  }

  php::augeas {
    'php-safe_mode_exec_dir':
      entry => 'PHP/safe_mode_exec_dir',
      value => nil;
  }

  php::augeas {
    'php-safe_mode_gid':
      entry => 'PHP/safe_mode_gid',
      value => 'Off';
  }

  php::augeas {
    'php-safe_mode_include_dir':
      entry => 'PHP/safe_mode_include_dir',
      value => nil;
  }

  php::augeas {
    'php-safe_mode':
      entry => 'PHP/safe_mode',
      value => 'Off';
  }

  php::augeas {
    'php-safe_mode_protected_env_vars':
      entry => 'PHP/safe_mode_protected_env_vars',
      value => 'LD_LIBRARY_PATH';
  }

  php::augeas {
    'php-sendmail_path':
      entry => 'PHP/sendmail_path',
      value => $sendmail_path;
  }

  php::augeas {
    'php-serialize_precision':
      entry => 'PHP/serialize_precision',
      value => '100';
  }

  php::augeas {
    'php-session.auto_start':
      entry => 'PHP/session.auto_start',
      value => '0';
  }

  php::augeas {
    'php-session.bug_compat_42':
      entry => 'PHP/session.bug_compat_42',
      value => 'Off';
  }

  php::augeas {
    'php-session.bug_compat_warn':
      entry => 'PHP/session.bug_compat_warn',
      value => 'Off';
  }

  php::augeas {
    'php-session.cache_expire':
      entry => 'PHP/session.cache_expire',
      value => '180';
  }

  php::augeas {
    'php-session.cache_limiter':
      entry => 'PHP/session.cache_limiter',
      value => 'nocache';
  }

  php::augeas {
    'php-session.cookie_domain':
      entry => 'PHP/session.cookie_domain',
      value => nil;
  }

  php::augeas {
    'php-session.cookie_httponly':
      entry => 'PHP/session.cookie_httponly',
      value => nil;
  }

  php::augeas {
    'php-session.cookie_lifetime':
      entry => 'PHP/session.cookie_lifetime',
      value => '0';
  }

  php::augeas {
    'php-session.cookie_path':
      entry => 'PHP/session.cookie_path',
      value => '/';
  }

  php::augeas {
    'php-session.entropy_file':
      entry => 'PHP/session.entropy_file',
      value => '/dev/urandom';
  }

  php::augeas {
    'php-session.entropy_length':
      entry => 'PHP/session.entropy_length',
      value => '0';
  }

  php::augeas {
    'php-session.gc_divisor':
      entry => 'PHP/session.gc_divisor',
      value => '1000';
  }

  php::augeas {
    'php-session.gc_maxlifetime':
      entry => 'PHP/session.gc_maxlifetime',
      value => '1440';
  }

  php::augeas {
    'php-session.gc_probability':
      entry => 'PHP/session.gc_probability',
      value => '1';
  }

  php::augeas {
    'php-session.hash_bits_per_character':
      entry => 'PHP/session.hash_bits_per_character',
      value => '5';
  }

  php::augeas {
    'php-session.hash_function':
      entry => 'PHP/session.hash_function',
      value => '0';
  }

  php::augeas {
    'php-session.name':
      entry => 'PHP/session.name',
      value => 'PHPSESSID';
  }

  php::augeas {
    'php-session.referer_check':
      entry => 'PHP/session.referer_check',
      value => nil;
  }

  php::augeas {
    'php-session.save_handler':
      entry => 'PHP/session.save_handler',
      value => 'files';
  }

  php::augeas {
    'php-session.save_path':
      entry => 'PHP/session.save_path',
      value => '/tmp'
  }

  file { '/var/lib/php5/session':
    ensure => 'directory',
    group  => 'www-data',
    mode   => '0770',
  }

  php::augeas {
    'php-session.serialize_handler':
      entry => 'PHP/session.serialize_handler',
      value => 'php';
  }

  php::augeas {
    'php-session.use_cookies':
      entry => 'PHP/session.use_cookies',
      value => '1';
  }

  php::augeas {
    'php-session.use_only_cookies':
      entry => 'PHP/session.use_only_cookies',
      value => '1';
  }

  php::augeas {
    'php-session.use_trans_sid':
      entry => 'PHP/session.use_trans_sid',
      value => '0';
  }

  php::augeas {
    'php-short_open_tag':
      entry => 'PHP/short_open_tag',
      value => 'On';
  }

  php::augeas {
    'php-SMTP':
      entry => 'PHP/SMTP',
      value => $smtp_host;
  }

  php::augeas {
    'php-smtp_port':
      entry => 'PHP/smtp_port',
      value => $smtp_port;
  }

  php::augeas {
    'php-soap.wsdl_cache_dir':
      entry => 'PHP/soap.wsdl_cache_dir',
      value => '/tmp';
  }

  php::augeas {
    'php-soap.wsdl_cache_enabled':
      entry => 'PHP/soap.wsdl_cache_enabled',
      value => '1';
  }

  php::augeas {
    'php-soap.wsdl_cache_ttl':
      entry => 'PHP/soap.wsdl_cache_ttl',
      value => '86400';
  }

  php::augeas {
    'php-sql.safe_mode':
      entry => 'PHP/sql.safe_mode',
      value => 'Off';
  }

  php::augeas {
    'php-sybct.allow_persistent':
      entry => 'PHP/sybct.allow_persistent',
      value => 'On';
  }

  php::augeas {
    'php-sybct.max_links':
      entry => 'PHP/sybct.max_links',
      value => '-1';
  }

  php::augeas {
    'php-sybct.max_persistent':
      entry => 'PHP/sybct.max_persistent',
      value => '-1';
  }

  php::augeas {
    'php-sybct.min_client_severity':
      entry => 'PHP/sybct.min_client_severity',
      value => '10';
  }

  php::augeas {
    'php-sybct.min_server_severity':
      entry => 'PHP/sybct.min_server_severity',
      value => '10';
  }

  php::augeas {
    'php-tidy.clean_output':
      entry => 'PHP/tidy.clean_output',
      value => 'Off';
  }

  php::augeas {
    'php-track_errors':
      entry => 'PHP/track_errors',
      value => 'Off';
  }

  php::augeas {
    'php-unserialize_callback_func':
      entry => 'PHP/unserialize_callback_func',
      value => nil;
  }

  php::augeas {
    'php-upload_max_filesize':
      entry => 'PHP/upload_max_filesize',
      value => '512M';
  }

  php::augeas {
    'php-url_rewriter.tags':
      entry => 'PHP/url_rewriter.tags',
      value => 'a';
  }

  php::augeas {
    'php-user_dir':
      entry => 'PHP/user_dir',
      value => nil;
  }

  php::augeas {
    'php-variables_order':
      entry => 'PHP/variables_order',
      value => 'GPCS';
  }

  php::augeas {
    'php-y2k_compliance':
      entry => 'PHP/y2k_compliance',
      value => 'On';
  }

  php::augeas {
    'php-zlib.output_compression':
      entry => 'PHP/zlib.output_compression',
      value => 'Off';
  }

}
