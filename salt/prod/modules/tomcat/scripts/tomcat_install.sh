#!/bin/sh

source /etc/profile

TOMCAT_PKG_PATH={{ tomcat_pkg_path }}
TOMCAT_PKG_NAME={{ tomcat_pkg_name }}
TOMCAT_PATH={{ tomcat_path }}
TOMCAT_NAME={{ tomcat_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${TOMCAT_PKG_PATH}
rm -rf ${TOMCAT_PKG_NAME}
rm -rf ${TOMCAT_PATH}/${TOMCAT_PKG_NAME}
rm -rf ${TOMCAT_PATH}/${TOMCAT_NAME}
tar xf ${TOMCAT_PKG_NAME}.tar.gz
mv ${TOMCAT_PKG_NAME} ${TOMCAT_PATH}/${TOMCAT_PKG_NAME}

[ -d ${TOMCAT_PATH}/${TOMCAT_PKG_NAME} ] && ln -s ${TOMCAT_PATH}/${TOMCAT_PKG_NAME} ${TOMCAT_PATH}/${TOMCAT_NAME}
