
FROM centos:6

MAINTAINER Minh Lam

ENV DOCKER_USER_ID 501
ENV DOCKER_USER_GID 20

ENV BOOT2DOCKER_ID 1000
ENV BOOT2DOCKER_GID 50

EXPOSE 80
EXPOSE 3306

#Install requirement packages
#RUN yum groups mark install "Development Tools" -y
RUN yum install epel-release -y
RUN yum install centos-release-scl -y
#RUN yum install -y nfs-utils m4 bison curl curl-devel supervisor git screen pciutils wget gcc gcc-c++ openssl openssl-devel ncurses ncurses-devel expat-devel make && yum -y clean all
RUN yum -y install \
nfs-utils m4 bison curl curl-devel supervisor git screen pciutils wget gcc gcc-c++ openssl openssl-devel ncurses \
ncurses-devel expat-devel make \
pcre \
pcre-devel \
gd \
gd-* \
gmp \
gmp-devel \
libc-client-devel  \
mhash \
mhash-devel \
libtool \
libtool-libs \
termcap \
libtermcap \
patch \
libtermcap-devel \
gdbm-devel \
autoconf \
zlib* \
libxml* \
freetype* \
libpng* \
apr \
apr-devel \
apr-util-devel \
libmcrypt-devel \
libtool-ltdl-devel \
libjpeg* && yum -y clean all

# Add image configuration and scripts
ADD supporting_files/start-mysqld.sh /start-mysqld.sh
ADD supporting_files/start-apache2.sh /start-apache2.sh
ADD supporting_files/create_mysql_users.sh /create_mysql_users.sh
ADD supporting_files/status.sh /status.sh
ADD supporting_files/supervisord.conf /etc/supervisord.conf

#install from source
COPY ["tmp/*","/tmp/"]
COPY ["supporting_files/install-packages.sh","/tmp/install-packages.sh"]
RUN chmod +x /tmp/install-packages.sh
RUN ["sh","-x","/tmp/install-packages.sh"]

ADD supporting_files/run.sh /run.sh
RUN chmod 755 /*.sh; \
    mkdir -p /root/check_empty_dir/; \
    mkdir -p /root/check_empty_dir/apache2/; \
    mkdir -p /root/check_empty_dir/php/; \
    mkdir -p /root/check_empty_dir/mysql/; \
    mv /usr/local/mysql/* /root/check_empty_dir/mysql/; \
    mv /usr/local/apache2/* /root/check_empty_dir/apache2/; \
    mv /usr/local/php5/* /root/check_empty_dir/php/;

CMD ["/run.sh"]

