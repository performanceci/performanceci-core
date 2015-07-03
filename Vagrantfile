# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "salt/roots/", "/srv/salt/"
  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
  end
  config.vm.provision :shell,
    privileged: false,
    inline: "cd /vagrant "\
    "&& bundle install "\
    "&& bundle exec rails s -p 4567"
end
