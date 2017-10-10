#!/usr/bin/env bash

sudo apt update
sudo apt install -y isc-dhcp-server
sudo cp /vagrant/configfiles/isc-dhcp-server.vm1 /etc/default/isc-dhcp-server
sudo cp /vagrant/configfiles/dhcpd.conf.vm1 /etc/dhcp/dhcpd.conf
sudo service isc-dhcp-server restart
sudo route add -net 192.168.20.0 netmask 255.255.255.0 dev enp0s8
