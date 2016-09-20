#!/bin/sh

source /etc/profile

PHP_PKG_PATH={{ php_pkg_path }}
PHP_PKG_NAME={{ php_pkg_name }}
PHP_PATH={{ php_path }}
PHP_NAME={{ php_name }}
PHP_USER={{ php_user}}


# 添加运行用户
[ `grep ${PHP_USER} /etc/passwd |wc -l` -eq 0 ] && useradd ${PHP_USER}
# 安装依赖软件包
arrayPackages=(gcc pcre-devel openssl-devel freetype-devel libpng-devel gd-devel libcurl-devel libxslt-devel libxslt-devel zlib-devel libxml2-devel libjpeg-devel libjpeg-turbo-devel libiconv-devel libtool libtool-ltdl-devel libmcrypt-devel)
for package in ${arrayPackages[*]}
  do
        [ `rpm -qa ${package} |wc -l` -eq 0 ] && yum install -y ${package} 1>> /dev/null
done

# 解压软件包
cd ${PHP_PKG_PATH}
rm -rf ${PHP_PKG_NAME}
rm -rf ${PHP_PATH}/${PHP_PKG_NAME}
rm -rf ${PHP_PATH}/${PHP_NAME}
tar xf ${PHP_PKG_NAME}.tar.gz
cd ${PHP_PKG_NAME}
./configure \
--prefix=${PHP_PATH}/${PHP_PKG_NAME} \
--with-iconv-dir=${PHP_PATH}/libiconv \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-mysql=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-mysqli \
--enable-embedded-mysqli \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-fpm \
--enable-mbstring \
--with-mcrypt \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-short-tags \
--enable-static \
--with-xsl \
--with-fpm-user=${PHP_USER} \
--with-fpm-group=${PHP_USER} \
--enable-ftp  1>> /dev/null

make 1>>/dev/null && make install 1>>/dev/null 
/bin/cp php.ini-production ${PHP_PATH}/${PHP_PKG_PATH}/lib/php.ini 
/bin/cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
rm -rf ${PHP_PKG_PATH}/${PHP_PKG_NAME}

cd ${PHP_PATH}/${PHP_PKG_PATH}
cp etc/php-fpm.conf.default etc/php-fpm.conf

[ -d ${PHP_PATH}/${PHP_PKG_NAME} ] && ln -s ${PHP_PATH}/${PHP_PKG_NAME} ${PHP_PATH}/${PHP_NAME}
