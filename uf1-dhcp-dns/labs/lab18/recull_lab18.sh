#!/bin/bash

##
## segons Isma: "un fichero que hace cosas"
## "...como los catalanes" 
##

rm -rf out
mkdir out
# mv1
vagrant ssh lab18vm1 -c "cp /etc/default/isc-dhcp-server /vagrant/out/isc-dhcp-server.vm1"
vagrant ssh lab18vm1 -c "cp /etc/dhcp/dhcpd.conf /vagrant/out/dhcpd.conf.vm1"
vagrant ssh lab18vm1 -c "route -n | tee /vagrant/out/route.vm1"
vagrant ssh lab18vm1 -c "service isc-dhcp-server status | tee /vagrant/out/status.vm1"
# mv2
vagrant ssh lab18vm2 -c "cp /etc/default/isc-dhcp-server /vagrant/out/isc-dhcp-server.vm2"
vagrant ssh lab18vm2 -c "cp /etc/dhcp/dhcpd.conf /vagrant/out/dhcpd.conf.vm2"
vagrant ssh lab18vm2 -c "route -n | tee /vagrant/out/route.vm2"
vagrant ssh lab18vm2 -c "service isc-dhcp-server status | tee /vagrant/out/status.vm2"
# mv4 - relay
vagrant ssh lab18vm4 -c "sudo apt install -y debconf-utils"
vagrant ssh lab18vm4 -c "debconf-get-selections | grep isc | tee /vagrant/out/debconf.vm4"
vagrant ssh lab18vm4 -c "cat /proc/sys/net/ipv4/ip_forward | tee /vagrant/out/proc_sys_net_ipv4_ip__forward.vm4"
vagrant ssh lab18vm4 -c "cat /proc/sys/net/ipv4/conf/all/secure_redirects | tee /vagrant/out/proc_sys_net_ipv4_conf_all_secure__redirects.vm4"
vagrant ssh lab18vm4 -c "service isc-dhcp-relay status | tee /vagrant/out/relay-status.vm4"
## els tres passes següents indiquen si ha "arribat" ip als 3 pc que la "demanen"
# mv3 
vagrant ssh lab18vm3 -c "ip a | tee /vagrant/out/ip_a.vm3"  
# mv5
vagrant ssh lab18vm5 -c "ip a | tee /vagrant/out/ip_a.vm5"  
# mv6
vagrant ssh lab18vm6 -c "ip a | tee /vagrant/out/ip_a.vm6"  
tar cvzf puja_m_al_drive_$USER.tar.gz out



