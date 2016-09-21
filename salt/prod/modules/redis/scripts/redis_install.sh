#!/bin/sh

source /etc/profile

REDIS_PKG_PATH={{ redis_pkg_path }}
REDIS_PKG_NAME={{ redis_pkg_name }}
REDIS_PATH={{ redis_path }}
REDIS_NAME={{ redis_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${REDIS_PKG_PATH}
rm -rf ${REDIS_PKG_NAME}
rm -rf ${REDIS_PATH}/${REDIS_PKG_NAME}
rm -rf ${REDIS_PATH}/${REDIS_NAME}

tar xf ${REDIS_PKG_NAME}.tar.gz
cd ${REDIS_PKG_NAME}
make PREFIX=${REDIS_PATH}/${REDIS_PKG_NAME} MALLOC=jemalloc install 1>>/dev/null && \
cp src/redis-trib.rb ${REDIS_PATH}/${REDIS_PKG_NAME}/bin
mkdir -p ${REDIS_PATH}/${REDIS_PKG_NAME}/{etc,data,log}
rm -rf ${REDIS_PKG_PATH}/${REDIS_PKG_NAME}

[ -d ${REDIS_PATH}/${REDIS_PKG_NAME} ] && ln -s ${REDIS_PATH}/${REDIS_PKG_NAME} ${REDIS_PATH}/${REDIS_NAME}
