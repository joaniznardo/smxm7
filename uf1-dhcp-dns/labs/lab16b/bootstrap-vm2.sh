#!/usr/bin/env bash

sudo apt update
sudo apt install -y isc-dhcp-server
sudo cp /vagrant/lab16bconfig/isc-dhcp-server.vm2 /etc/default/isc-dhcp-server
sudo cp /vagrant/lab16bconfig/dhcpd.conf.vm2 /etc/dhcp/dhcpd.conf
sudo service isc-dhcp-server restart
