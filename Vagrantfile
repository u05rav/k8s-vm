# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  
  config.vm.provision "shell", path: "setup-docker.sh"
  config.vm.provision "shell", path: "setup-k8s.sh"

  config.vm.network "forwarded_port", guest: 2375, host:2375
  config.vm.network "forwarded_port", guest: 6443, host:6443
end