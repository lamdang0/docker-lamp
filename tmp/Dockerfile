
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
RUN yum install -y nfs-utils m4 bison curl curl-devel supervisor git screen pciutils wget gcc gcc-c++ openssl openssl-devel ncurses ncurses-devel expat-devel make && yum -y clean all
RUN yum -y install \
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

#install from source
COPY ["tmp/*","/tmp/"]
COPY ["supporting_files/install-packages.sh","/tmp/install-packages.sh"]
RUN chmod +x /tmp/install-packages.sh
RUN ["sh","-x","/tmp/install-packages.sh"]


# Add image configuration and scripts
ADD supporting_files/start-mysqld.sh /start-mysqld.sh
ADD supporting_files/start-apache2.sh /start-apache2.sh
ADD supporting_files/run.sh /run.sh
ADD supporting_files/create_mysql_users.sh /create_mysql_users.sh
RUN chmod 755 /*.sh
ADD supporting_files/supervisord.conf /etc/supervisord.conf

CMD ["/run.sh"]

