#!/bin/bash

source /etc/profile.d/freeipa-settings.sh

cat > /etc/hosts << EOM
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
${NFS_CLIENT_IP} ${NFS_CLIENT_HOSTNAME} nfs-client
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
--ip-address=${NFS_CLIENT_IP} \
--force-ntpd \
--mkhomedir \
-U

mkdir -p ${NFS_MOUNT}


# Create a systemd mount unit for NFS share
cat > ${NFS_MOUNT_UNIT_FILE} << EOM
[Unit]
Description=Secured NFS share
After=network.target

[Mount]
What=${NFS_SERVER_IP}:${NFS_SHARE}
Where=${NFS_MOUNT}
Type=nfs
Options=_netdev,sec=krb5p

[Install]
WantedBy=multi-user.target
EOM

systemctl daemon-reload

systemctl enable nfs-client.target
systemctl start nfs-client.target

systemctl enable ${NFS_MOUNT_UNIT_NAME}
systemctl start ${NFS_MOUNT_UNIT_NAME}

# Test
# su - $NFS_USERNAME
# kinit
# cd ${NFS_MOUNT}
# touch hello.txt
