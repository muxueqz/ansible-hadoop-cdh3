#!/bin/sh
yum install mysql-server -y
#curl -L 'http://www.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.15.tar.gz/from/http://mysql.he.net/' | tar xz
#sudo cp mysql-connector-java-5.1.15/mysql-connector-java-5.1.15-bin.jar /usr/lib/hive/lib/

#CREATE DATABASE metastore;
#USE metastore;
#SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.7.0.mysql.sql;
/etc/init.d/mysqld restart
mysqladmin create hive_metastore
mysql hive_metastore < /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-0.7.0.mysql.sql
USER_NAME='hiveuser'
PASSWORD='adf729166c730f817b0de9354bd58b8f2ff4db80'
DB_NAME='hive_metastore'
HOSTNAME='hadoop1'

#CREATE USER '${USER_NAME}'@'%' IDENTIFIED BY '$PASSWORD';
echo "
GRANT SELECT,INSERT,UPDATE,DELETE ON ${DB_NAME}.* TO '${USER_NAME}'@'${HOSTNAME}' IDENTIFIED BY '$PASSWORD';
REVOKE ALTER,CREATE ON ${DB_NAME}.* FROM '${USER_NAME}'@'${HOSTNAME}';
" > /dev/shm/hive_metestore_auth.sql
mysql hive_metastore < /dev/shm/hive_metestore_auth.sql
