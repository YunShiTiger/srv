#!/bin/sh

source /etc/profile

MYSQL_PKG_PATH={{ mysql_pkg_path }}
MYSQL_PKG_NAME={{ mysql_pkg_name }}
MYSQL_PATH={{ mysql_path }}
MYSQL_NAME={{ mysql_name }}
MYSQL_USER={{ mysql_user}}


# 添加运行用户
[ `grep ${MYSQL_USER} /etc/passwd |wc -l` -eq 0 ] && useradd -s /sbin/nologin -M ${MYSQL_USER}

# 安装依赖软件包
arrayPackages=(gcc gcc-c++)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${MYSQL_PKG_PATH}
rm -rf ${MYSQL_PKG_NAME}
rm -rf ${MYSQL_PATH}/${MYSQL_NAME}
rm -rf ${MYSQL_PATH}/mysql

tar xf ${MYSQL_PKG_NAME}.tar.gz
mv ${MYSQL_PKG_NAME} ${MYSQL_PATH}/${MYSQL_NAME}

[ -d ${MYSQL_PATH}/${MYSQL_NAME} ] && ln -s ${MYSQL_PATH}/${MYSQL_NAME} ${MYSQL_PATH}/mysql
