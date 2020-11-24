#!/bin/sh
APDIR="/usr/local/apache2"
MDIR="/usr/local/mysql"
MDATA="/home/MYSQL"
PHPDIR="/usr/local/php5"
DIR_CHECK="/root/check_empty_dir"

#Check empty php conf dir

if ! [ "$(ls -A $PHPDIR)" ]; then
        \cp -rp $DIR_CHECK/php/* $PHPDIR
fi

#Check empty apache conf dir
# if ! [ "$(ls -A $APDIR)" ]; then
#         \cp -rp $DIR_CHECK/apache2/* $APDIR
# fi
if [[ ! -f $APDIR/bin/httpd ]];then
        \cp -rp $DIR_CHECK/apache2/* $APDIR
        #rsync -avz $DIR_CHECK/apache2/* $APDIR --exclude logs/ 
fi


#Check empty mysql conf dir
if ! [ "$(ls -A $MDIR)" ]; then
        \cp -rp $DIR_CHECK/mysql/* $MDIR
fi

#Delete temp dir 
rm $DIR_CHECK/* -rf

#if [[ ! -d $MDATA/data/mysql ]]; then
if ! [ "$(ls -A $MDATA/data)" ]; then
        echo "=> An empty or uninitialized MySQL volume is detected in MYSQL data directory"
        echo "=> Installing MySQL ..."
        $MDIR/bin/mysql_install_db
        /bin/bash create_mysql_users.sh
else
        echo "Using current database."
fi



sleep 3
echo "Starting supervisor"
exec supervisord -n
