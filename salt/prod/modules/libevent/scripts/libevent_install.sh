#!/bin/sh

source /etc/profile

LIBEVENT_PKG_PATH={{ libevent_pkg_path }}
LIBEVENT_PKG_NAME={{ libevent_pkg_name }}
LIBEVENT_PATH={{ libevent_path }}
LIBEVENT_NAME={{ libevent_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${LIBEVENT_PKG_PATH}
rm -rf ${LIBEVENT_PKG_NAME}
rm -rf ${LIBEVENT_PATH}/${LIBEVENT_PKG_NAME}
rm -rf ${LIBEVENT_PATH}/${LIBEVENT_NAME}

tar xf ${LIBEVENT_PKG_NAME}.tar.gz
cd ${LIBEVENT_PKG_NAME}
./configure \
--prefix=${LIBEVENT_PATH}/${LIBEVENT_PKG_NAME} 1>>/dev/null
make 1>>/dev/null && make install 1>>/dev/null && rm -rf ${LIBEVENT_PKG_PATH}/${LIBEVENT_PKG_NAME}

[ -d ${LIBEVENT_PATH}/${LIBEVENT_PKG_NAME} ] && ln -s ${LIBEVENT_PATH}/${LIBEVENT_PKG_NAME} ${LIBEVENT_PATH}/${LIBEVENT_NAME}
