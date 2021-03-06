#!/bin/bash

MDIR="/usr/local/mysql"
PWSD_MYSQL="lamplamp"
MDATA="/home/MYSQL"

chown mysql.mysql $MDATA -R
$MDIR/mysql.server start
sleep 1
echo "Creating MySQL root user with password: $PWSD_MYSQL"

$MDIR/bin/mysql -uroot -S /tmp/mysqld3306.sock -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$PWSD_MYSQL');"
$MDIR/bin/mysql -uroot --password="$PWSD_MYSQL" -S /tmp/mysqld3306.sock -e "CREATE USER 'root'@'%' IDENTIFIED BY '$PWSD_MYSQL'; grant all privileges on *.* to 'root'@'%' with grant option; flush privileges;"


echo "enjoy!"
echo "========================================================================"

$MDIR/mysql.server stop
sleep 1
