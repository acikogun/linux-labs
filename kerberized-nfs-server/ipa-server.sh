#!/bin/bash

source /etc/profile.d/freeipa-settings.sh

cat > /etc/hosts << EOM
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${IPA_SERVER_IP} ${IPA_SERVER_HOSTNAME} ipa-server
EOM

# Install random number server that makes key generations faster
yum install -y rng-tools
systemctl enable rngd
systemctl start rngd

# Install FreeIPA server packages
yum install -y ipa-server ipa-server-dns

# Install FreeIPA and related services
ipa-server-install \
--domain=${IPA_DOMAIN} \
--realm=${IPA_REALM} \
--ds-password=${IPA_DS_PASS} \
--admin-password=${IPA_ADMIN_PASS} \
--hostname=${IPA_SERVER_HOSTNAME} \
--forwarder=${IPA_DNS_FORWARDER1} \
--forwarder=${IPA_DNS_FORWARDER2} \
--setup-dns \
--auto-reverse \
-U

nmcli con modify "${CON_PUB}" ipv4.dns 127.0.0.1,1.1.1.1
nmcli con modify "${CON_PRI}" ipv4.dns 127.0.0.1,1.1.1.1

nmcli con mod "${CON_PUB}" ipv4.ignore-auto-dns yes
nmcli con mod "${CON_PRI}" ipv4.ignore-auto-dns yes

systemctl restart NetworkManager

firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,dns}
firewall-cmd --add-service={freeipa-ldap,freeipa-ldaps,dns} --permanent

echo ${IPA_ADMIN_PASS} | kinit ${IPA_PRINCIPAL}

ipa host-add --ip-address=${NFS_SERVER_IP} ${NFS_SERVER_HOSTNAME}
ipa host-add --ip-address=${NFS_CLIENT_IP} ${NFS_CLIENT_HOSTNAME}

ipa service-add ${IPA_NFS_SERVICE} --force

echo ${NFS_USERPASS} | ipa user-add ${NFS_USERNAME} \
--first=nfs \
--last=user \
--shell=/bin/bash \
--setattr krbPasswordExpiration=20270826073247Z \
--password
