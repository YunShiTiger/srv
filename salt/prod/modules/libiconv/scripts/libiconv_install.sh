#!/bin/sh

source /etc/profile

LIBICONV_PKG_PATH={{ libiconv_pkg_path }}
LIBICONV_PKG_NAME={{ libiconv_pkg_name }}
LIBICONV_PATH={{ libiconv_path }}
LIBICONV_NAME={{ libiconv_name }}

# 安装依赖软件包
arrayPackages=(gcc)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${LIBICONV_PKG_PATH}
rm -rf ${LIBICONV_PKG_NAME}
rm -rf ${LIBICONV_PATH}/${LIBICONV_PKG_NAME}
rm -rf ${LIBICONV_PATH}/${LIBICONV_NAME}

tar xf ${LIBICONV_PKG_NAME}.tar.gz
cd ${LIBICONV_PKG_NAME}
./configure \
--prefix=${LIBICONV_PATH}/${LIBICONV_PKG_NAME} 1>>/dev/null
make 1>>/dev/null && make install 1>>/dev/null && rm -rf ${LIBICONV_PKG_PATH}/${LIBICONV_PKG_NAME}

[ -d ${LIBICONV_PATH}/${LIBICONV_PKG_NAME} ] && ln -s ${LIBICONV_PATH}/${LIBICONV_PKG_NAME} ${LIBICONV_PATH}/${LIBICONV_NAME}
