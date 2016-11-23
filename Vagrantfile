# -*- mode: ruby -*-
# vi: set ft=ruby :
require "yaml"

# The following plugins can (should?) be used with this project;
# * vagrant-cachier
# * vagrant-hostmanager
# * vagrant-triggers
# * vagrant-vbguest
# They can be installed by running `vagrant plugin install <plugin>`. See `vagrant plugin help` for more information.

fqdn = "dev.pdxfixit.com"
Vagrant.require_version '>= 1.6.0'

# Initialize config
def deep_merge!(target, data)
  merger = proc{|key, v1, v2|
    Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
  target.merge! data, &merger
end

# Copy and customize defaults.yaml.template => defaults.yaml to override
_config = {
    "synced_folders" => {},
}

# Local-specific config (not tracked by git) -- defaults.yaml
begin
  deep_merge!(_config, YAML.load(File.open(File.join(File.dirname(__FILE__), "node/#{fqdn}.yaml"), File::RDONLY).read))
rescue Errno::ENOENT
  begin
    deep_merge!(_config, YAML.load(File.open(File.join(File.dirname(__FILE__), "defaults.yaml"), File::RDONLY).read))
  rescue Errno::ENOENT
    # No defaults.yaml found -- that's OK; just use the defaults.
  end
end

Vagrant.configure("2") do |config|

  # Cache yum update files using vagrant-cachier, if installed
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.scope = :machine
  end

  if Vagrant.has_plugin?('vagrant-hostmanager')
    # include aliases
    config.hostmanager.aliases_on_separate_lines = true
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  end

  if Vagrant.has_plugin?('vagrant-triggers')
    # Restore databases
    config.trigger.after [:reload, :resume, :up], :force => true, :option => "value" do
      info "Restoring databases..."
      run_remote "[ -f /root/dbimport.sh ] && /root/dbimport.sh"
    end

    # Export databases
    config.trigger.before [:destroy, :halt, :reload, :suspend], :force => true, :option => "value" do
      info "Exporting databases..."
      run_remote "[ -f /root/dbexport.sh ] && /root/dbexport.sh"
    end
  end

  if _config.has_key?('synced_folders')
    FOLDERS = _config['synced_folders']
  end

  ##
  # Development
  ##
  config.vm.define :dev do |node|
    node.vm.box = "puppetlabs/ubuntu-12.04-64-nocm"
    node.vm.hostname = "#{fqdn}"

    if Vagrant.has_plugin?('vagrant-hostmanager')
      node.hostmanager.aliases = %w(alt.www.pdxfixit.com) # can be multiple aliases (space delimited)
    end

    node.ssh.forward_agent = true
    node.vm.network :private_network, ip: "192.168.47.10"
    node.vm.network :forwarded_port, guest: 22, host: 2200, id: "ssh"
    node.vm.network :forwarded_port, guest: 80, host: 80
    node.vm.network :forwarded_port, guest: 443, host: 443
    node.vm.network :forwarded_port, guest: 3306, host: 3306
    node.vm.network :forwarded_port, guest: 8080, host: 8080

    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096", "--cpus", "4", "--ioapic", "on", "--name", fqdn]
    end

    node.vm.synced_folder ".", "/pdxfixit/infra"
    node.vm.synced_folder ".", "/vagrant"
    node.vm.synced_folder "/databases", "/var/db"

    # web folders need explicit permissions here; the other synced folders can safely default to root ownership
    FOLDERS.each do |name, folders|
      if folders['host'] != '' && folders['guest'] != ''
        node.vm.synced_folder folders['host'], folders['guest'],
          id: name,
          owner: "www-data",
          group: "www-data",
          mount_options: ["dmode=775,fmode=664"]
      end
    end

    # Make sure we point the domains to localhost
    node.vm.provision "shell", path: "Setup.sh", run: "once"

    node.vm.post_up_message = "The PDXfixIT Development Environment is now ready for use."
  end

end
