#!/bin/bash

source /etc/profile.d/globals.sh

yum install -y policycoreutils-python vim curl bash-completion net-tools

systemctl start firewalld
systemctl enable firewalld

yum install -y httpd createrepo yum-utils
systemctl enable httpd

firewall-cmd --add-service=http
firewall-cmd --add-service=http --permanent

mkdir -p ${BASE_DIR}/{base,centosplus,extras,updates}

systemctl start httpd

cat > /etc/cron.daily/sync-repos.sh << EOM
reposync -g -l -d -m --repoid=base --newest-only --download-metadata --download_path=${BASE_DIR}
createrepo -g comps.xml "${BASE_DIR}/base"

reposync -g -l -d -m --repoid=updates --newest-only --download-metadata --download_path=${BASE_DIR}
createrepo "${BASE_DIR}/updates"

reposync -g -l -d -m --repoid=extras --newest-only --download-metadata --download_path=${BASE_DIR}
createrepo "${BASE_DIR}/extras"

reposync -g -l -d -m --repoid=centosplus --newest-only --download-metadata --download_path=${BASE_DIR}
createrepo "${BASE_DIR}/centosplus"

EOM

chmod 755 /etc/cron.daily/sync-repos.sh
source /etc/cron.daily/sync-repos.sh
restorecon -Rv /var/www/html
