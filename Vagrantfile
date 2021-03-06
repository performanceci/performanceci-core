# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  # Common
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.synced_folder "salt/pillar/", "/srv/pillar/"
  config.vm.synced_folder "salt/formulas/", "/srv/formulas/"
  config.vm.provision :salt do |salt|
    salt.bootstrap_options = "-P"
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end

  # Database
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.69.20"
  end

  # Hoster
  config.vm.define "docker" do |docker|
    docker.vm.hostname = "docker"
    docker.vm.network "private_network", ip: "192.168.69.30"
    docker.vm.provider "virtualbox" do |vbox|
      vbox.memory = 4096
    end
  end

  # Core product
  config.vm.define "core", primary: true do |core|
    core.vm.hostname = "core"
    core.vm.network "private_network", ip: "192.168.69.10"
    core.vm.network "forwarded_port", ip: "127.0.0.1", guest: 3000, host: 3000, protocol: 'tcp'
  end
end
