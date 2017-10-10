#!/usr/bin/env bash

sudo apt update
export DEBIAN_FRONTEND="noninteractive"
cat /vagrant/configfiles/debconf-isc-dhcp-relay.vm2 | debconf-set-selections
sudo apt install -q -y isc-dhcp-relay
##sudo cp /vagrant/configfiles/isc-dhcp-relay.vm2 /etc/default/isc-dhcp-relayr
sudo cp /vagrant/configfiles/sysctl.conf.vm2 /etc/sysctl.conf
sudo sysctl -p
sudo service isc-dhcp-relay restart
