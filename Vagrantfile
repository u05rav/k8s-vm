# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.network "private_network", type: "dhcp"

  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/xenial64"
    master.vm.hostname = "master"
  
    master.vm.provision "shell", path: "setup-docker.sh"
    master.vm.provision "shell", path: "setup-k8s.sh", args: "'create'"

    master.vm.network "forwarded_port", guest: 2375, host:2375
    master.vm.network "forwarded_port", guest: 6443, host:6443
  end


  (1..1).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = "node-#{i}"

      node.vm.provision "shell", path: "setup-docker.sh"
      node.vm.provision "shell", path: "setup-k8s.sh", args: "'join'"
    end
  end
end
