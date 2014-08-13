#!/bin/bash
# You can override config options very easily.
# Just create a custom options file; it may be version specific:
# - custom-options.sh
# - custom-options-5.sh
# - custom-options-5.3.sh
# - custom-options-5.3.1.sh
#
# Don't touch this file here - it would prevent you to just "svn up"
# your phpfarm source code.

version=$1
vmajor=$2
vminor=$3
vpatch=$4

#gcov='--enable-gcov'
configoptions="\
--enable-bcmath \
--enable-calendar \
--enable-exif \
--enable-ftp \
--enable-mbstring \
--enable-pcntl \
--enable-soap \
--enable-sockets \
--enable-sqlite-utf8 \
--enable-wddx \
--enable-zip \
--enable-fastcgi \
--enable-fpm \
--enable-sockets \
--enable-sysvsem \
--enable-sysvshm \
--enable-json \
--enable-libxml \
--enable-gd-native-ttf \
--with-mcrypt \
--with-curl \
--with-zlib \
--with-xmlrpc \
--with-openssl \
--with-gettext \
--with-bz2 \
--with-pcre-regex \
--with-mhash \
--with-mysql \
--with-mysqli \
--with-pdo-mysql \
--with-pear \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-vpx-dir \
--with-freetype-dir \
--with-gmp \
$gcov"

echo $version $vmajor $vminor $vpatch

custom="custom-options.sh"
[ -f $custom ] && source "$custom" $version $vmajor $vminor $vpatch
custom="custom-options-$vmajor.sh"
[ -f $custom ] && source "$custom" $version $vmajor $vminor $vpatch
custom="custom-options-$vmajor.$vminor.sh"
[ -f $custom ] && source "$custom" $version $vmajor $vminor $vpatch
custom="custom-options-$vmajor.$vminor.$vpatch.sh"
[ -f $custom ] && source "$custom" $version $vmajor $vminor $vpatch
