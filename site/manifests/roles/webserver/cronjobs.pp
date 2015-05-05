# Set up standard cron jobs
class site::roles::webserver::cronjobs ($cronjobs = hiera('cronjobs', {})) {

  create_resources(cron, $cronjobs)

}
