#!/bin/bash

if [ "$1" == "" ]; then
    echo -e "\nYou must pass the PHP version\n"
    exit 1
fi

version="$1"

if [ ! -d "../inst/php-$version" ]; then
    echo -e "\nPHP version $version in not installed\n"
    exit 1
fi

#current location
basedir="$(pwd)"
#directory phps get installed into
instbasedir="$(readlink -f "$basedir/../inst")"
#directory this specific version gets installed into
instdir="$instbasedir/php-$version"
#directory where config are setup
etcdir="/etc/php/$version/fpm"

if [ ! -f "$instdir/etc/php-fpm.conf.default" ]; then
    echo -e "\nThere are not a $instdir/etc/php-fpm.conf.default available to version $version"
    echo -e "\nInstallation aborted\n"

    exit 1
fi

if [ ! -d "$etcdir" ]; then
    install -d "$etcdir"
fi

if [ ! -d "$etcdir/php-fpm.d" ]; then
    install -d "$etcdir/php-fpm.d"
fi

echo -e "\nCopy $instdir/php-fpm.conf.default file to $etcdir/php-fpm.conf"

replacements='
    sed "s#;include=etc#include=$etcdir#" \
    | sed "s#$instdir/etc#$etcdir#" \
    | sed "s#;pid = run/php-fpm.pid#pid = $instdir/var/run/php-fpm.pid#" \
    | sed "s#;error_log = log/php-fpm.log#error_log = $instdir/var/log/php-fpm.log#" \
    | sed "s#;syslog.ident = php-fpm#syslog.ident = php-fpm-$version#" \
    | sed "s#listen = 127.0.0.1:9000#listen = $instdir/var/run/php-fpm.sock#g" \
    | sed "s#;listen.owner = www-data#listen.owner = www-data#g" \
    | sed "s#;listen.group = www-data#listen.group = www-data#g" \
'

cat "$instdir/etc/php-fpm.conf.default" | eval "$replacements" > "$etcdir/php-fpm.conf"

if [ -d "$instdir/etc/php-fpm.d" ]; then
    for i in $(ls "$instdir/etc/php-fpm.d/"*.default); do
        echo -e "\nCopy $i file to $etcdir/php-fpm.d/"

        cat "$i" | eval "$replacements" > "$etcdir/php-fpm.d/$(basename $i | sed 's/.default//')"
    done
fi

if [ ! -d "$instdir/var" ]; then
    install -d "$instdir/var"
fi

chown -R www-data:www-data "$instdir/var"

echo -e "\nInstalling php.ini in $etcdir/"

cp -p "$instdir/lib/php.ini" "$etcdir/"

echo -e "\nInstalling php-fpm-$version service /etc/init.d/php-fpm-$version"

cat "$basedir/templates/php-fpm.init.d" \
    | sed -e "s#VERSION#$version#g" -e "s#INSTDIR#$instdir#g" -e "s#ETCDIR#$etcdir#g" \
    > "/etc/init.d/php-fpm-$version"

chmod 755 "/etc/init.d/php-fpm-$version"

echo -e "\nInstalling php-fpm-$version service /etc/init/php-fpm-$version.conf"

cat "$basedir/templates/php-fpm.init.conf" \
    | sed -e "s#VERSION#$version#g" -e "s#INSTDIR#$instdir#g" -e "s#ETCDIR#$etcdir#g" \
    > "/etc/init/php-fpm-$version.conf"

echo -e "\nFinished. Install service as:"
echo -e "\nupdate-rc.d php-fpm-$version defaults"
echo -e "\nservice php-fpm-$version start"
echo ""

exit 0
