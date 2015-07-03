# -*- mode: ruby -*-
# vi: set ft=ruby :

setup = <<SCRIPT
cd /vagrant
bundle install
bundle exec rake db:seed
bundle exec rake db:migrate
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.network "private_network", ip: "192.168.69.10"
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end
  config.vm.provision :shell do |shell|
    shell.privileged = false
    shell.inline     = setup
  end
end
