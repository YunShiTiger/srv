#!/bin/sh

source /etc/profile

ZABBIX_PKG_PATH="/usr/local/src"
ZABBIX_PKG_NAME="zabbix-3.0.4"
ZABBIX_PATH="/usr/local"
ZABBIX_NAME="zabbix-server"
ZABBIX_USER=zabbix


# 添加运行用户
[ `grep ${ZABBIX_USER} /etc/passwd |wc -l` -eq 0 ] && useradd -s /sbin/nologin -M ${ZABBIX_USER}
# 安装依赖软件包
arrayPackages=(libxml2-devel net-snmp-devel curl-devel postgresql-devel sqlite-devel libssh2-devel mysql-devel)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${ZABBIX_PKG_PATH}
rm -rf ${ZABBIX_PKG_NAME}
rm -f ${ZABBIX_PATH}/${ZABBIX_NAME}
tar xf ${ZABBIX_PKG_NAME}.tar.gz
cd ${ZABBIX_PKG_NAME}
./configure \
--prefix=${ZABBIX_PATH}/${ZABBIX_PKG_NAME} \
--enable-server \
--with-mysql \
--with-net-snmp \
--with-libcurl \
--enable-java \
--with-ssh2 \
--enable-ipv6 \
--with-libxml2 1>>/dev/null

make 1>>/dev/null && make install 1>>/dev/null && rm -rf ${ZABBIX_PKG_PATH}/${ZABBIX_PKG_NAME}

[ -d ${ZABBIX_PATH}/${ZABBIX_PKG_NAME} ] && ln -s ${ZABBIX_PATH}/${ZABBIX_PKG_NAME} ${ZABBIX_PATH}/${ZABBIX_NAME}
