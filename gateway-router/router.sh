#!/bin/bash

source /etc/profile.d/globals.sh


nmcli con mod "${CON_PUB}" connection.zone external
nmcli con mod "${CON_PRI}" connection.zone internal

nmcli con mod "${CON_PRI}" ipv4.addresses 10.0.0.1/24
nmcli con mod "${CON_PRI}" ipv4.method manual
nmcli con up "${CON_PRI}"

yum install -y dhcp
systemctl enable dhcpd

cat > /etc/dhcp/dhcpd.conf << EOM
subnet 10.0.0.0 netmask 255.255.255.0 {
        option routers                  10.0.0.1;
        option subnet-mask              255.255.255.0;
        option domain-search              "localdomain";
        option domain-name-servers       1.1.1.1, 8.8.8.8;
	range 10.0.0.2 10.0.0.200;
}
EOM
