# mod_security
class site::roles::webserver::security (
  $base_rules = [
    'modsecurity_crs_20_protocol_violations.conf',
    'modsecurity_crs_21_protocol_anomalies.conf',
    'modsecurity_crs_23_request_limits.conf',
    'modsecurity_crs_30_http_policy.conf',
    'modsecurity_crs_35_bad_robots.conf',
    'modsecurity_35_bad_robots.data',
    'modsecurity_35_scanners.data',
    'modsecurity_crs_40_generic_attacks.conf',
    'modsecurity_40_generic_attacks.data',
    'modsecurity_crs_41_sql_injection_attacks.conf',
    'modsecurity_41_sql_injection_attacks.data',
    'modsecurity_crs_41_xss_attacks.conf',
    'modsecurity_crs_42_tight_security.conf',
    'modsecurity_crs_45_trojans.conf',
    'modsecurity_crs_47_common_exceptions.conf',
#    'modsecurity_crs_48_local_exceptions.conf',
    'modsecurity_crs_49_inbound_blocking.conf',
    'modsecurity_crs_50_outbound.conf',
    'modsecurity_50_outbound.data',
    'modsecurity_50_outbound_malware.data',
    'modsecurity_crs_59_outbound_blocking.conf',
    'modsecurity_crs_60_correlation.conf',
  ],
  $optional_rules = [
    'modsecurity_crs_10_ignore_static.conf',
    'modsecurity_crs_13_xml_enabler.conf', # The rules in this file will trigger the XML parser upon an XML request
    'modsecurity_crs_16_session_hijacking.conf', # allows ModSecurity to track session cookies, ensure against hijacking
    'modsecurity_crs_25_cc_known.conf', # Detect CC# in input, log transaction and sanitize
    'modsecurity_crs_42_comment_spam.conf',
    'modsecurity_42_comment_spam.data',
    'modsecurity_crs_46_av_scanning.conf', # Modify the operator to use the correct AV scanning script/tool
    'modsecurity_crs_47_skip_outbound_checks.conf', # Skip outbound inspection on requests for text content which have no parameters
    #'modsecurity_crs_55_application_defects.conf', # various http header, cookie and encoding checks
  ],
  $experimental_rules = [
  ],
) {

  # mod_security
  apache::mod { 'unique_id': }
  apache::mod { 'security':
    id            => 'security2_module',
    lib           => 'mod_security2.so',
    lib_path      => '/usr/lib/apache2/modules',
    loadfile_name => 'security.load',
    package       => 'libapache2-modsecurity',
  }

  $apache_version = $::apache::apache_version
  file { 'security.conf':
    content => template('site/modsecurity.conf.erb'),
    ensure  => 'file',
    notify  => Service['httpd'],
    path    => "${::apache::mod_dir}/security.conf",
    require => Exec["mkdir ${::apache::mod_dir}"],
  }

  # Rules
  file { 'activated_rules':
    ensure  => 'directory',
    path    => '/usr/share/modsecurity-crs/activated_rules',
    purge   => true,
    require => Package['libapache2-modsecurity'],
  }

  apache_modsecurity_base_rules { $base_rules: }
  apache_modsecurity_optional_rules { $optional_rules: }
  apache_modsecurity_experimental_rules { $experimental_rules: }

}

define apache_modsecurity_base_rules {
  file { $name:
    ensure  => 'link',
    notify  => Service['httpd'],
    path    => "/usr/share/modsecurity-crs/activated_rules/$name",
    require => File['activated_rules'],
    target  => "/usr/share/modsecurity-crs/base_rules/$name",
  }
}

define apache_modsecurity_optional_rules {
  file { $name:
    ensure  => 'link',
    notify  => Service['httpd'],
    path    => "/usr/share/modsecurity-crs/activated_rules/$name",
    require => File['activated_rules'],
    target  => "/usr/share/modsecurity-crs/optional_rules/$name",
  }
}

define apache_modsecurity_experimental_rules {
  file { $name:
    ensure  => 'link',
    notify  => Service['httpd'],
    path    => "/usr/share/modsecurity-crs/activated_rules/$name",
    require => File['activated_rules'],
    target  => "/usr/share/modsecurity-crs/experimental_rules/$name",
  }
}
