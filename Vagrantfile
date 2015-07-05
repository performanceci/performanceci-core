# -*- mode: ruby -*-
# vi: set ft=ruby :

setup = <<SCRIPT
cd /vagrant
export DB_HOST='192.168.69.20'
bundle exec rake db:seed
bundle exec rake db:migrate
SCRIPT

Vagrant.configure(2) do |config|

  # Common
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.synced_folder "salt/formulas/", "/srv/formulas/"
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

  # Database
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.69.20"
  end

  # Core product
  config.vm.define "core", primary: true do |core|
    core.vm.hostname = "core"
    core.vm.network "private_network", ip: "192.168.69.10"
    core.vm.provision :shell do |shell|
      shell.privileged = false
      shell.inline     = setup
    end
  end
end
