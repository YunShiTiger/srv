#!/bin/sh

source /etc/profile

NGINX_PKG_PATH={{ nginx_pkg_path }}
NGINX_PKG_NAME={{ nginx_pkg_name }}
NGINX_PATH={{ nginx_path }}
NGINX_NAME={{ nginx_name }}
NGINX_USER={{ nginx_user}}


# 添加运行用户
[ `grep ${NGINX_USER} /etc/passwd |wc -l` -eq 0 ] && useradd ${NGINX_USER}
# 安装依赖软件包
arrayPackages=(gcc gd-devel pcre-devel pcre openssl-devel openssl gzip)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa $package |wc -l` -eq 0 ] && yum install -y $package 1>> /dev/null
done

# 解压软件包
cd ${NGINX_PKG_PATH}
rm -rf ${NGINX_PKG_NAME}
rm -rf ${NGINX_PATH}/${NGINX_PKG_NAME}
rm -rf ${NGINX_PATH}/${NGINX_NAME}
tar xf ${NGINX_PKG_NAME}.tar.gz
cd ${NGINX_PKG_NAME}
./configure \
--prefix=${NGINX_PATH}/${NGINX_PKG_NAME} \
--user=${NGINX_USER} \
--group=${NGINX_USER} \
--with-http_ssl_module \
--with-http_stub_status_module \
--lock-path=/var/lock/subsys/nginx.lock \
--with-http_flv_module \
--with-http_realip_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-pcre 1>>/dev/null

make 1>>/dev/null && make install 1>>/dev/null && \
rm -rf ${NGINX_PKG_PATH}/${NGINX_PKG_NAME}

[ -d ${NGINX_PATH}/${NGINX_PKG_NAME} ] && ln -s ${NGINX_PATH}/${NGINX_PKG_NAME} ${NGINX_PATH}/${NGINX_NAME}
mkdir -p ${NGINX_PATH}/${NGINX_NAME}/conf/vhosts
