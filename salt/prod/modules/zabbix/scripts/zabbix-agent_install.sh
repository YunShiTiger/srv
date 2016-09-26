#!/bin/sh

source /etc/profile

ZABBIX_PKG_PATH={{ zabbix_pkg_path }}
ZABBIX_PKG_NAME={{ zabbix_pkg_name }}
ZABBIX_PATH={{ zabbix_path }}
ZABBIX_NAME={{ zabbix_name }}
ZABBIX_USER="zabbix"


# 添加运行用户
[ `grep ${ZABBIX_USER} /etc/passwd |wc -l` -eq 0 ] && useradd -s /sbin/nologin -M ${ZABBIX_USER}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${ZABBIX_PKG_PATH}
rm -rf ${ZABBIX_PKG_NAME}
rm -rf ${ZABBIX_PATH}/${ZABBIX_PKG_NAME}
rm -rf ${ZABBIX_PATH}/${ZABBIX_NAME}

tar xf ${ZABBIX_PKG_NAME}.tar.gz
cd ${ZABBIX_PKG_NAME}
./configure \
--prefix=${ZABBIX_PATH}/${ZABBIX_PKG_NAME} \
--enable-agent 1>>/dev/null

make 1>>/dev/null && make install 1>>/dev/null && rm -rf ${ZABBIX_PKG_PATH}/${ZABBIX_PKG_NAME}
mkdir ${ZABBIX_PATH}/${ZABBIX_PKG_NAME}/scripts

[ -d ${ZABBIX_PATH}/${ZABBIX_PKG_NAME} ] && ln -s ${ZABBIX_PATH}/${ZABBIX_PKG_NAME} ${ZABBIX_PATH}/${ZABBIX_NAME}
