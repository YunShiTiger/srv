#!/bin/sh

source /etc/profile

JAVA_PKG_PATH={{ java_pkg_path }}
JAVA_PKG_NAME={{ java_pkg_name }}
JAVA_PATH={{ java_path }}
JAVA_NAME={{ java_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${JAVA_PKG_PATH}
rm -rf ${JAVA_NAME}
rm -rf ${JAVA_PATH}/${JAVA_NAME}
rm -rf ${JAVA_PATH}/jdk

tar xf ${JAVA_PKG_NAME}.tar.gz
mv ${JAVA_NAME} ${JAVA_PATH}/${JAVA_NAME}

[ -d ${JAVA_PATH}/${JAVA_NAME} ] && ln -s ${JAVA_PATH}/${JAVA_NAME} ${JAVA_PATH}/jdk
