#!/bin/sh

### ***************************************************************************
#
# No description yet.
#
# Dependencies:
# - docker, kubernetes, kubectl,  mysql-cli
#
# Made(Creator)  Cain Chen/CHEN YI CHI
# Contact:       shu90129@gmail.com
# Created:       2018
# Last modified: August 9, 2018
# Passed(tested) for:
#   - macOS 10 to 10.13.5
#   - Ubuntu 14 to 17
#
# Major used at: Kubernetes, Docker
#
### **************************************************************************

export KUBECONFIG=$KUBECONFIG:~/.kube/<Add in here>
export dbbackup=<Add in here>
evn=<Add in here>
db_hsot=mariadb-0
kubectl -n $env exec $db_host -- sh /opt/DB-backup.sh
kubectl -n $env cp $db_host:/opt/dbbackup $dbbackup/
mysqldump -u backuper -pbackuper wp > $DBbackup/wp-$(date +%Y%m%d%H%M).sql
mysqldump -u backuper -pbackuper wpdb > $DBbackup/wpdb-$(date +%Y%m%d%H%M).sql
mysqldump -u backuper -pbackuper wp2db > $DBbackup/wp2db-$(date +%Y%m%d%H%M).sql
tar -zcf $DBbackup/UAT-mariadb-1-wpdb_bk_$(date +%Y%m%d%H%M).tar $DBbackup/*.sql
rm -f $DBbackup/*.sql && rm -f $DBbackup/*$(date +"%Y%m%d%H" -d'-1 Hour')*.tar
rm -f $DBbackup/*$(date +"%Y%m%d%H" -d'-1 day')*.tar
