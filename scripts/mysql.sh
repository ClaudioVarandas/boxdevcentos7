#!/bin/bash

echo "Installing Mysql 5.7"

cat /etc/redhat-release

wget -i http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
sudo yum -y localinstall mysql57-community-release-el7-7.noarch.rpm
sudo yum -y install mysql-community-server

sudo systemctl start mysqld

MYSQL_TEMP_PASS="`sudo grep 'temporary.*root@localhost' /var/log/mysqld.log | sed 's/.*root@localhost: //'`"

echo "Mysql installed..."

mysql --user="root" --password="${MYSQL_TEMP_PASS}" --connect-expired-password -e exit 2>/dev/null

STATUS=`echo $?`

if [ $STATUS -ne 1 ]; then

mysql --user=root -p${MYSQL_TEMP_PASS} --connect-expired-password <<_EOF_
 ALTER USER 'root'@'localhost' IDENTIFIED BY '8qUKb7@99H3plrAz';
 DELETE FROM mysql.user WHERE User='';
 DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
 DROP DATABASE IF EXISTS test;
 DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
 FLUSH PRIVILEGES;
_EOF_

echo "Mysql instalation secured..."

else

echo "Mysql already secured or password invalid ..."

fi
