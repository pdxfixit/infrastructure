# All site-specific PHP settings
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

  include apache::mod::php

  class { '::php':
    settings => {
      'PHP/allow_call_time_pass_reference' => 'Off',
      'PHP/allow_url_fopen' => 'Off',
      'PHP/allow_url_include' => 'Off',
      'PHP/asp_tags' => 'Off',
      'PHP/auto_append_file' => nil,
      'PHP/auto_globals_jit' => 'On',
      'PHP/auto_prepend_file' => nil,
      'PHP/bcmath.scale' => '0',
      'PHP/date.timezone' => 'America/Los_Angeles',
      'PHP/default_mimetype' => 'text/html',
      'PHP/default_socket_timeout' => '60',
      'PHP/define_syslog_variables' => 'Off',
      'PHP/disable_classes' => nil,
      'PHP/disable_functions' => nil,
      'PHP/display_errors' => $display_errors,
      'PHP/display_startup_errors' => 'Off',
      'PHP/doc_root' => nil,
      'PHP/enable_dl' => 'Off',
      'PHP/engine' => 'On',
      'PHP/error_reporting' => $error_reporting,
      'PHP/expose_php' => 'Off',
      'PHP/file_uploads' => 'On',
      'PHP/html_errors' => 'Off',
      'PHP/ignore_repeated_errors' => 'Off',
      'PHP/ignore_repeated_source' => 'Off',
      'PHP/implicit_flush' => 'Off',
      'PHP/log_errors_max_len' => '1024',
      'PHP/log_errors' => 'On',
      'PHP/magic_quotes_gpc' => 'Off',
      'PHP/magic_quotes_runtime' => 'Off',
      'PHP/magic_quotes_sybase' => 'Off',
      'PHP/mail.add_x_header' => 'On',
      'PHP/max_execution_time' => '30',
      'PHP/max_input_time' => '60',
      'PHP/memory_limit' => '256M',
      'PHP/mssql.allow_persistent' => 'On',
      'PHP/mssql.compatability_mode' => 'Off',
      'PHP/mssql.max_links' => '-1',
      'PHP/mssql.max_persistent' => '-1',
      'PHP/mssql.min_error_severity' => '10',
      'PHP/mssql.min_message_severity' => '10',
      'PHP/mssql.secure_connection' => 'Off',
      'PHP/mysql.allow_persistent' => 'Off',
      'PHP/mysql.connect_timeout' => '60',
      'PHP/mysql.default_host' => nil,
      'PHP/mysql.default_password' => nil,
      'PHP/mysql.default_port' => nil,
      'PHP/mysql.default_socket' => nil,
      'PHP/mysql.default_user' => nil,
      'PHP/mysqli.default_host' => nil,
      'PHP/mysqli.default_port' => '3306',
      'PHP/mysqli.default_pw' => nil,
      'PHP/mysqli.default_socket' => nil,
      'PHP/mysqli.default_user' => nil,
      'PHP/mysqli.max_links' => '-1',
      'PHP/mysqli.reconnect' => 'Off',
      'PHP/mysql.max_links' => '-1',
      'PHP/mysql.max_persistent' => '-1',
      'PHP/mysql.trace_mode' => 'Off',
      'PHP/odbc.allow_persistent' => 'On',
      'PHP/odbc.check_persistent' => 'On',
      'PHP/odbc.defaultbinmode' => '1',
      'PHP/odbc.defaultlrl' => '4096',
      'PHP/odbc.max_links' => '-1',
      'PHP/odbc.max_persistent' => '-1',
      'PHP/output_buffering' => '0',
      'PHP/pgsql.allow_persistent' => 'On',
      'PHP/pgsql.auto_reset_persistent' => 'Off',
      'PHP/pgsql.ignore_notice' => '0',
      'PHP/pgsql.log_notice' => '0',
      'PHP/pgsql.max_links' => '-1',
      'PHP/pgsql.max_persistent' => '-1',
      'PHP/post_max_size' => '512M',
      'PHP/precision' => '14',
      'PHP/register_argc_argv' => 'Off',
      'PHP/register_globals' => 'Off',
      'PHP/register_long_arrays' => 'Off',
      'PHP/report_memleaks' => 'On',
      'PHP/request_order' => 'GP',
      'PHP/safe_mode_allowed_env_vars' => 'PHP_',
      'PHP/safe_mode_exec_dir' => nil,
      'PHP/safe_mode_gid' => 'Off',
      'PHP/safe_mode_include_dir' => nil,
      'PHP/safe_mode' => 'Off',
      'PHP/safe_mode_protected_env_vars' => 'LD_LIBRARY_PATH',
      'PHP/sendmail_path' => $sendmail_path,
      'PHP/serialize_precision' => '100',
      'PHP/session.auto_start' => '0',
      'PHP/session.bug_compat_42' => 'Off',
      'PHP/session.bug_compat_warn' => 'Off',
      'PHP/session.cache_expire' => '180',
      'PHP/session.cache_limiter' => 'nocache',
      'PHP/session.cookie_domain' => nil,
      'PHP/session.cookie_httponly' => nil,
      'PHP/session.cookie_lifetime' => '0',
      'PHP/session.cookie_path' => '/',
      'PHP/session.entropy_file' => '/dev/urandom',
      'PHP/session.entropy_length' => '0',
      'PHP/session.gc_divisor' => '1000',
      'PHP/session.gc_maxlifetime' => '1440',
      'PHP/session.gc_probability' => '1',
      'PHP/session.hash_bits_per_character' => '5',
      'PHP/session.hash_function' => '0',
      'PHP/session.name' => 'PHPSESSID',
      'PHP/session.referer_check' => nil,
      'PHP/session.save_handler' => 'files',
      'PHP/session.save_path' => '/tmp',
      'PHP/session.serialize_handler' => 'php',
      'PHP/session.use_cookies' => '1',
      'PHP/session.use_only_cookies' => '1',
      'PHP/session.use_trans_sid' => '0',
      'PHP/short_open_tag' => 'On',
      'PHP/SMTP' => $smtp_host,
      'PHP/smtp_port' => $smtp_port,
      'PHP/soap.wsdl_cache_dir' => '/tmp',
      'PHP/soap.wsdl_cache_enabled' => '1',
      'PHP/soap.wsdl_cache_ttl' => '86400',
      'PHP/sql.safe_mode' => 'Off',
      'PHP/sybct.allow_persistent' => 'On',
      'PHP/sybct.max_links' => '-1',
      'PHP/sybct.max_persistent' => '-1',
      'PHP/sybct.min_client_severity' => '10',
      'PHP/sybct.min_server_severity' => '10',
      'PHP/tidy.clean_output' => 'Off',
      'PHP/track_errors' => 'Off',
      'PHP/unserialize_callback_func' => nil,
      'PHP/upload_max_filesize' => '512M',
      'PHP/url_rewriter.tags' => 'a',
      'PHP/user_dir' => nil,
      'PHP/variables_order' => 'GPCS',
      'PHP/y2k_compliance' => 'On',
      'PHP/zlib.output_compression' => 'Off',
    },
    extensions => {
      curl => {},
    },
  }

  # CentOS and Ubuntu ship with different default PHP modules
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      php::extension { 'pdo': }
      php::extension { 'gd': }
      php::extension { 'mbstring': }
      php::extension { 'xml': }
    }
    'Debian', 'Ubuntu': {
      case $::lsbdistcodename {
        'xenial': {

        }
        default: {
          php::extension { 'gd': }
          package { 'libpcre3-dev': ensure => 'installed' }
        }
      }
    }
    default: {
      php::extension { 'gd': }
    }
  }

  # file { '/var/lib/php5/session':
  #   ensure => 'directory',
  #   group  => 'www-data',
  #   mode   => '0770',
  # }

}
