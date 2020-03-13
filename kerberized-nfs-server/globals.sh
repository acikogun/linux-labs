#!/bin/bash

export CON_PUB="System eth0"
export CON_PRI="System eth1"
export IPA_DOMAIN="ipa.acik.work"
export IPA_REALM=$(echo ${IPA_DOMAIN} | tr '[:lower:]' '[:upper:]')
export IPA_DS_PASS="w7t$&H7PAR6v&G" # Directory server password
export IPA_PRINCIPAL="admin"
export IPA_ADMIN_PASS="917c3SaQsbJ9R"
export IPA_DNS_FORWARDER1="1.1.1.1"
export IPA_DNS_FORWARDER2="8.8.8.8"

export NFS_USERNAME="nfsuser"
export NFS_USERPASS="NYK9PCV71"
export NFS_SHARE="/kerberized_nfs_share"
export NFS_MOUNT="/mnt/nfs"
# If mount point is "/xyz/abc", systemd mount file name must be "xyz-abc.mount"
export NFS_MOUNT_UNIT=$(echo ${NFS_MOUNT} | cut -c 2- | tr "/" "-")
export NFS_MOUNT_UNIT_NAME="${NFS_MOUNT_UNIT}.mount"
export NFS_MOUNT_UNIT_FILE="/etc/systemd/system/${NFS_MOUNT_UNIT_NAME}"

export IPA_SERVER_IP="192.168.50.11"
export NFS_SERVER_IP="192.168.50.12"
export NFS_CLIENT_IP="192.168.50.13"
export IPA_SERVER_HOSTNAME="ipa-server.${IPA_DOMAIN}"
export NFS_SERVER_HOSTNAME="nfs-server.${IPA_DOMAIN}"
export NFS_CLIENT_HOSTNAME="nfs-client.${IPA_DOMAIN}"
export IPA_NFS_SERVICE="nfs/${NFS_SERVER_HOSTNAME}"
