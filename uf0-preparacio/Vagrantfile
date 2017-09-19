# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

BOX_IMAGE = "bento/ubuntu-16.04"

Vagrant.configure("2") do |config|
  config.vm.define "vm1" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "vm1"
    subconfig.vm.network :private_network, ip: "172.16.1.1"
    
    subconfig.vm.provider "virtualbox" do |vb|
       vb.name = "labvm1"
       vb.memory = 512
       vb.linked_clone = true
    end
  end
##  config.ssh.username = "smxm7"

  config.vm.define "vm2" do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "vm2"
    subconfig.vm.network :private_network, ip: "172.16.1.2"
    
    subconfig.vm.provider "virtualbox" do |vb|
       vb.name = "labvm2"
       vb.memory = 512
       vb.linked_clone = true
    end
  end
##  config.ssh.username = "smxm7"

  config.vm.define "vm3", autostart: false do |subconfig|
    subconfig.vm.box = BOX_IMAGE
    subconfig.vm.hostname = "vm3"
    subconfig.vm.network :private_network, ip: "172.16.1.3"
    
    subconfig.vm.provider "virtualbox" do |vb|
       vb.name = "labvm3"
       vb.memory = 512
       vb.linked_clone = true
    end
  end
##  config.ssh.username = "smxm7"

# Install avahi on all machines     
  config.vm.provision "shell", inline: <<-SHELL
     apt-get install -y avahi-daemon libnss-mdns   
  SHELL

end
