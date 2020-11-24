#!/bin/sh
APDIR="/usr/local/apache2"
MDIR="/usr/local/mysql"
MDATA="/home/MYSQL"

create_default_apache(){
        if [[ ! -f $APDIR/conf/httpd.conf ]]; then
                cat /tmp/httpd.conf > $APDIR/conf/httpd.conf
        fi
}

create_default_mysql(){
        if [[ ! -d $MDATA/data/mysql ]]; then
                echo "=> An empty or uninitialized MySQL volume is detected in MYSQL data directory"
                echo "=> Installing MySQL ..."
                mkdir $MDATA/data
                mkdir $MDATA/log
                chown -R mysql.mysql $MDATA
                $MDIR/bin/mysql_install_db
                /start-mysqld.sh
                /create_mysql_users.sh
        fi
}
create_default_apache
create_default_mysql
/start-mysqld.sh
/start-apache2.sh

echo "Create default mysql data if mysql cannot start"
STTMYSQL=$($MDIR/bin/mysqladmin ping -h 127.0.0.1 --silent)
if [ $? -ne 0 ]; then
        echo "Mysql can't start properly"
        echo "Start mysql with default database"
        rm $MDATA/* -rf 
        create_default_mysql
else
        $MDIR/mysql.server stop
fi

echo "Create default one if apache cannot start"
STTAP=$(ps aux | grep apache2)
if [ $? -ne 0 ]; then
        echo "Apache can't start properly"
        echo "Start apache with default configuration"
        rm $APDIR/conf/httpd.conf -rf 
        create_default_apache
else
        $APDIR/bin/httpd -k stop

fi

sleep 3
echo "Starting supervisor"
exec supervisord -n
