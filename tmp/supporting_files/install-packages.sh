#!/bin/bash
set -euo pipefail

SOURCE="/tmp"
APVER="2.4.3"
MYVER="5.0.67"
PHPVER="5.2.17"
MDATA="/home/MYSQL"
INSDIR="mysql"
APDIR="/usr/local/apache2"
MDIR="/usr/local/mysql"

mv /etc/localtime /tmp/old.timezone
ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

cd $SOURCE
echo "0. Install requirement package"

ln -fs /usr/lib64/libjpeg.so /usr/lib/
ln -fs /usr/lib64/libpng.so /usr/lib/

echo "1. Install Apache 2.4.3"
wget https://archive.apache.org/dist/httpd/httpd-2.4.3.tar.gz
tar xzvf httpd-$APVER.tar.gz

#define DEFAULT_SERVER_LIMIT 2048
\cp prefork.c ./httpd-2.4.3/server/mpm/prefork/prefork.c -rfa

#define DEFAULT_SERVER_LIMIT 20
\cp worker.c ./httpd-2.4.3/server/mpm/worker/worker.c -rfa

tar xzvf apr-1.4.6.tar.gz
tar xzvf apr-util-1.4.1.tar.gz

mv apr-1.4.6 ./httpd-2.4.3/srclib/apr
mv apr-util-1.4.1 ./httpd-2.4.3/srclib/apr-util


#configure HTTPD
cd httpd-$APVER
./configure \
--prefix=/usr/local/apache2 \
--enable-so \
--enable-mods-shared-all \
--enable-module=so \
--enable-ssl \
--with-ssl \
--enable-rewrite \
--with-included-apr \
--with-mpm=prefork
make
make install

#rm -rf $APDIR/conf/httpd.conf
cat /tmp/httpd.conf > $APDIR/conf/httpd.conf

echo "2. Install MYSQL 5.0.67"
adduser -d /nonexistent -s /sbin/nologin mysql
cd $SOURCE
wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.0.67.tar.gz
tar xzvf mysql-$MYVER.tar.gz
cd mysql-$MYVER
./configure --prefix=/usr/local/$INSDIR \
--localstatedir=$MDATA/data \
--enable-assembler \
--with-extra-charset=sjis,ujis,euckr \
--with-federated-storage-engine \
--with-client-ldflags=-all-static \
--with-mysqld-ldflags=-all-static \
--enable-thread-safe-client
make
make install

cd /usr/local
chown -R mysql.mysql $INSDIR -R

mkdir $MDATA
#mkdir $MDATA/data
#mkdir $MDATA/log

chown -R mysql.mysql $MDATA

rm /etc/my.cnf -rf
cp -rf /tmp/my.cnf /usr/local/$INSDIR/my.cnf

cd /usr/local
chown -R mysql.mysql $INSDIR -R

cp /usr/local/$INSDIR/share/mysql/mysql.server /usr/local/$INSDIR

chmod 755 $MDIR/mysql.server

#$MDIR/bin/mysql_install_db

chown -R mysql.mysql $MDATA
#rm $MDATA/log/* -rf 
#rm $MDATA/data/* -rf 


echo "3. Install PHP"
cd $SOURCE
/sbin/ldconfig

wget http://museum.php.net/php5/php-5.2.17.tar.gz
tar zxvf php-$PHPVER.tar.gz
cp /tmp/php.patch ./php-$PHPVER/

\cp /tmp/php_functions.c ./php-$PHPVER/sapi/apache2handler/ -rf

cd php-$PHPVER
patch -p0 -b < php.patch

FLAGS="-O3 -funroll-loops -fomit-frame-pointer" \
./configure \
--with-apxs2=$APDIR/bin/apxs \
--with-mysql=$MDIR \
--with-mysqli=$MDIR/bin/mysql_config \
--disable-debug \
--with-regex=php \
--with-iconv \
--with-gdbm \
--with-gd \
--with-curl \
--with-jpeg-dir \
--with-png-dir \
--with-freetype-dir  \
--with-png-dir \
--with-exec-dir=/usr/bin \
--enable-sigchild \
--enable-dba \
--enable-magic-quotes \
--enable-safe-mode \
--enable-gd-native-ttf \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbstring \
--enable-gd-native-ttf \
--with-config-file-path=$APDIR/conf \
--enable-ftp \
--with-mcrypt \
--with-zlib \
--enable-sockets \
--enable-zend-multibyte \
--enable-pdo=shared \
--with-pdo-sqlite=shared \
--with-sqlite=shared \
--with-pdo-mysql=shared,$MDIR \
--with-openssl \
--enable-pcntl \
--enable-zip \
--prefix=/usr/local/php5

make
make install

ln -s /usr/local/php5/bin/php /usr/local/bin/php

cd $SOURCE
rm -rf  php-$PHPVER*
rm -rf httpd-$APVER*
rm -rf mysql-$MYVER*
rm -rf apr-*

