# Jenkins
class site::roles::jenkins {

  class { '::jenkins':
    configure_firewall => true,
    lts                => true,
    plugin_hash => {
      'antisamy-markup-formatter' => { version => 'latest' },
      'bitbucket'                 => { version => 'latest' },
      'bitbucket-oauth'           => { version => 'latest' },
      'credentials'               => { version => 'latest' },
      'cvs'                       => { version => 'latest' },
      'git'                       => { version => 'latest' },
      'github'                    => { version => 'latest' },
      'github-oauth'              => { version => 'latest' },
      'javadoc'                   => { version => 'latest' },
      'junit'                     => { version => 'latest' },
      'ldap'                      => { version => 'latest' },
      'mailer'                    => { version => 'latest' },
      'matrix-auth'               => { version => 'latest' },
      'maven-plugin'              => { version => 'latest' },
      'pam-auth'                  => { version => 'latest' },
      'script-security'           => { version => 'latest' },
      'ssh-credentials'           => { version => 'latest' },
      'subversion'                => { version => 'latest' },
      'translation'               => { version => 'latest' },
    },
  }

#  jenkins::credentials { 'github-deploy-key':
#    password            => '',
#    private_key_or_path => hiera('::github-deploy-key'),
#  }

  # TODO: plugins
  # TODO: secure access
  # TODO: jobs

}
