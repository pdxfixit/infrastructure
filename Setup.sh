#!/bin/bash

# Puppet manifests must be uploaded to /root/pdxfixit-infra before running this script.

if [ ! -d "/vagrant" ] ; then
  hostname "server.pdxfixit.com"
  while read l; do
    if [[ "$l" =~ "docroot:" ]] ; then
      mkdir -p ${l/#docroot: }
    fi
  done < node/server.pdxfixit.com.yaml
else
  hostname "dev.pdxfixit.com"
fi

echo "Installing packages..."
apt-get update -qq

# 14.04 else 12.04
CODENAME=`lsb_release -c | cut -f2`
if [ "${CODENAME}" == "trusty" ] ; then
  apt-get install -y -qq wget git ruby zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev
else
  apt-get install -y -qq wget git ruby1.9.1-full ruby1.9.1 ruby1.9.1-dev ri1.9.1 build-essential libruby1.9.1 libssl-dev zlib1g-dev libaugeas-ruby1.9.1 rubygems

  echo "Updating ruby..."
  update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.1 400 \
    --slave   /usr/share/man/man1/ruby.1.gz ruby.1.gz /usr/share/man/man1/ruby1.9.1.1.gz \
    --slave   /usr/bin/ri ri /usr/bin/ri1.9.1 \
    --slave   /usr/bin/irb irb /usr/bin/irb1.9.1 \
    --slave   /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.1
  update-alternatives --set gem /usr/bin/gem1.9.1
fi

# Setup puppet
echo "Installing Puppet..."
wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb
for count in {1..30}; do
  puppet && break
  echo "attempt # ${count} - waiting 10 seconds..."
  sleep 10
  dpkg -i puppetlabs-release-precise.deb && rm puppetlabs-release-precise.deb
  apt-get -qq update
  apt-get install -y -qq puppet
done

mkdir -p /etc/puppet/environments/production/modules

# r10k installs puppet modules
puppet apply -e "class {'site::base::r10k': dir => '/etc/puppet/environments/production'}" --modulepath=/root/pdxfixit-infra
puppet apply -e "class {'site::base::puppetconf': environment => 'production'}" --modulepath="/root/pdxfixit-infra:/etc/puppet/environments/production/modules"

# configure hiera via puppet and then run puppet apply
echo "Running Puppet..."
puppet apply -e 'class { "site::base::hiera::install": }'
puppet apply /root/pdxfixit-infra/site/manifests

touch /root/setup-complete
