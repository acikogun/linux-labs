#!/bin/bash

source /etc/profile.d/freeipa-settings.sh

cat > /etc/hosts << EOM
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${NFS_SERVER_IP} ${NFS_SERVER_HOSTNAME} nfs-server
EOM

yum install -y ipa-client

# Use ipa-server's DNS server as primary DNS server
nmcli con modify "${CON_PUB}" ipv4.dns ${IPA_SERVER_IP},1.1.1.1
nmcli con modify "${CON_PRI}" ipv4.dns ${IPA_SERVER_IP},1.1.1.1

nmcli con mod "${CON_PUB}" ipv4.ignore-auto-dns yes
nmcli con mod "${CON_PRI}" ipv4.ignore-auto-dns yes

systemctl restart NetworkManager

# Join realm
ipa-client-install \
--domain=${IPA_DOMAIN} \
--realm=${IPA_REALM} \
--server=${IPA_SERVER_HOSTNAME} \
--principal=${IPA_PRINCIPAL} \
--password=${IPA_ADMIN_PASS} \
--ip-address=${NFS_SERVER_IP} \
--force-ntpd \
--mkhomedir \
-U

# Login as kerberos admin
echo ${IPA_ADMIN_PASS} | kinit ${IPA_PRINCIPAL}

# Get keytab from ipa-server
ipa-getkeytab -s ${IPA_SERVER_HOSTNAME} -p ${IPA_NFS_SERVICE} -k /etc/krb5.keytab

# Create shared folder
mkdir -p ${NFS_SHARE}
chmod 0777 ${NFS_SHARE}

# Set SELinux context for shared folder
semanage fcontext -a -t public_content_rw_t "${NFS_SHARE}(/.*)?"
restorecon -Rv ${NFS_SHARE}

# Allow nfs clients to connect
firewall-cmd --add-service={nfs,rpc-bind,mountd}
firewall-cmd --add-service={nfs,rpc-bind,mountd} --permanent

# Share
echo "${NFS_SHARE} ${NFS_CLIENT_HOSTNAME}(rw,sec=krb5p)" > /etc/exports

# Enable and start nfs services
systemctl enable rpcbind
systemctl enable nfs-server
systemctl start rpcbind
systemctl start nfs-server

# exportfs -avr
# showmount -e localhost
