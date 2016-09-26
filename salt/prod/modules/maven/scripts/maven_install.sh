#!/bin/sh

source /etc/profile

MAVEN_PKG_PATH={{ maven_pkg_path }}
MAVEN_PKG_NAME={{ maven_pkg_name }}
MAVEN_PATH={{ maven_path }}
MAVEN_NAME={{ maven_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${MAVEN_PKG_PATH}
rm -rf ${MAVEN_PKG_NAME}
rm -rf ${MAVEN_PATH}/${MAVEN_PKG_NAME}
rm -rf ${MAVEN_PATH}/${MAVEN_NAME}

unzip -q ${MAVEN_PKG_NAME}-bin.zip
mv ${MAVEN_PKG_NAME} ${MAVEN_PATH}/${MAVEN_PKG_NAME}

[ -d ${MAVEN_PATH}/${MAVEN_PKG_NAME} ] && ln -s ${MAVEN_PATH}/${MAVEN_PKG_NAME} ${MAVEN_PATH}/${MAVEN_NAME}
