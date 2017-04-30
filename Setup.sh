#!/bin/bash

# Puppet manifests must be uploaded to /pdxfixit/infra before running this script.

if [ ! -d "/vagrant" ] ; then
  hostname "server.pdxfixit.com"
  ENV="production"
  # ensure vhost folders are created
  while read l; do
    if [[ "$l" =~ "docroot:" ]] ; then
      mkdir -p ${l/#docroot: }
    fi
  done < nodes/server.pdxfixit.com.yaml
else
  hostname "dev.pdxfixit.com"
  ENV="dev"
fi

echo "Installing packages..."
apt-get update -qq

if [ ! -d "/pdxfixit/infra" ]; then
  echo "Cloning PDXfixIT infrastructure-as-code..."

  if [ ! -d "/pdxfixit/" ]; then
    mkdir /pdxfixit
  fi

  apt-get install -y -qq git
  git clone https://github.com/pdxfixit/infrastructure.git /pdxfixit/infra

  if [ ! -f "/pdxfixit/infra/Puppetfile" ]; then
    echo "ERROR: Could not clone PDXfixIT infrastructure."
    exit 1
  fi
fi

# 16.04 (xenial) vs 14.04 (trusty) vs 12.04 (precise)
CODENAME=`lsb_release -c | cut -f2`
if [ "${CODENAME}" == "trusty" ] ; then
  apt-get install -y -qq wget ruby zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev
elif [ "${CODENAME}" == "precise" ] ; then
  apt-get install -y -qq wget ruby1.9.1-full ruby1.9.1 ruby1.9.1-dev ri1.9.1 build-essential libruby1.9.1 libssl-dev zlib1g-dev libaugeas-ruby1.9.1 rubygems

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
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-$CODENAME.deb
for count in {1..30}; do
  if [ -x /opt/puppetlabs/bin/puppet ]; then
   break
  fi
  echo "attempt # ${count} - waiting 10 seconds..."
  sleep 10
  dpkg -i puppetlabs-release-pc1-$CODENAME.deb && rm puppetlabs-release-pc1-$CODENAME.deb
  apt-get update -qq
  apt-get install -y -qq puppet-agent
done

mkdir -p /etc/puppetlabs/code/environments/${ENV}/modules

# r10k installs puppet modules
/opt/puppetlabs/bin/puppet apply -e "class {'site::base::r10k': environment => '${ENV}'}" --modulepath=/pdxfixit/infra
/opt/puppetlabs/bin/puppet apply -e "class {'site::base::puppetconf': environment => '${ENV}'}" --modulepath="/pdxfixit/infra:/etc/puppetlabs/code/environments/${ENV}/modules"

# configure hiera via puppet and then run puppet apply
echo "Running Puppet..."
/opt/puppetlabs/bin/puppet apply /pdxfixit/infra/site/manifests/base/hiera.pp
/opt/puppetlabs/bin/puppet apply /pdxfixit/infra/site/manifests

touch /pdxfixit/setup-complete
