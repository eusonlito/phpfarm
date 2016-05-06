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
etcdir="/etc/php/$version"

echo -e "\nInstalling cgi-bin wrapper in /var/www/cgi-bin/php-cgi-$version"

if [ ! -d /var/www/cgi-bin/ ]; then
    install -d /var/www/cgi-bin/
fi

cat "$basedir/templates/php-cgi" | sed "s/VERSION/$version/g" > "/var/www/cgi-bin/php-cgi-$version"

chmod 755 "/var/www/cgi-bin/php-cgi-$version"

echo -e "\nInstalling php.ini in $etcdir/cgi/"

if [ ! -d "$etcdir/cgi/" ]; then
    install -d "$etcdir/cgi/"
fi

cp -p "$instdir/lib/php.ini" "$etcdir/cgi/"

echo -e "\nConfiguring Apache /etc/apache2/conf-available/phpfarm.conf"

if [ ! -f "/etc/apache2/conf-available/phpfarm.conf" ]; then
    cp "$basedir/templates/apache-phpfarm.conf" "/etc/apache2/conf-available/phpfarm.conf"

    cd /etc/apache2/conf-enabled

    ln -s ../conf-available/phpfarm.conf .

    cd "$basedir"
fi

if [ "$(grep "php-cgi-$version" /etc/apache2/conf-available/phpfarm.conf)" == "" ]; then
    echo "FastCGIServer /var/www/cgi-bin/php-cgi-$version -idle-timeout 5000" >> /etc/apache2/conf-available/phpfarm.conf
fi

echo -e "\nConfiguring Apache /etc/apache2/cgi-servers/php-$version.conf"

if [ ! -d /etc/apache2/cgi-servers/ ]; then
    install -d /etc/apache2/cgi-servers/
fi

cat "$basedir/templates/apache-php.conf" | sed "s/VERSION/$version/g" > "/etc/apache2/cgi-servers/php-$version.conf"

echo -e "\nAdd this line to VirtualHost configuration"
echo -e "\nInclude /etc/apache2/cgi-servers/php-$version.conf"
echo -e "\nAnd restart Apache"

echo -e "\nFinished\n\n"

exit 0
