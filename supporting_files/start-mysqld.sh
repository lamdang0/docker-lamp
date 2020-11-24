#!/bin/bash
MDIR="/usr/local/mysql"
MDATA="/home/MYSQL"
chown -R mysql.mysql $MDATA
exec /usr/local/mysql/bin/mysqld_safe
