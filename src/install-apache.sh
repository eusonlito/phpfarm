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

here="$(pwd)"

echo -e "\nInstalling cgi-bin wrapper in /var/www/cgi-bin/php-cgi-$version"

if [ ! -d /var/www/cgi-bin/ ]; then
    install -d /var/www/cgi-bin/
fi

cat "$here/templates/php-cgi" | sed "s/VERSION/$version/g" > "/var/www/cgi-bin/php-cgi-$version"

chmod 755 "/var/www/cgi-bin/php-cgi-$version"

echo -e "\nInstalling php.ini in /etc/php5/cgi/$version/"

if [ ! -d "/etc/php5/cgi/$version/" ]; then
    install -d "/etc/php5/cgi/$version/"
fi

cp -p "/opt/phpfarm/inst/php-$version/lib/php.ini" "/etc/php5/cgi/$version/"

echo -e "\nConfiguring Apache /etc/apache2/conf-available/phpfarm.conf"

if [ ! -f "/etc/apache2/conf-available/phpfarm.conf" ]; then
    cp "$here/templates/apache-phpfarm.conf" > "/etc/apache2/conf-available/phpfarm.conf"

    cd /etc/apache2/conf-enabled

    ln -s ../conf-available/phpfarm.conf .

    cd "$here"
fi

if [ "$(grep "php-cgi-$version" /etc/apache2/conf-available/phpfarm.conf)" == "" ]; then
    echo "FastCGIServer /var/www/cgi-bin/php-cgi-$version -idle-timeout 5000" >> /etc/apache2/conf-available/phpfarm.conf
fi

echo -e "\nConfiguring Apache /etc/apache2/cgi-servers/php-$version.conf"

if [ ! -d /etc/apache2/cgi-servers/ ]; then
    install -d /etc/apache2/cgi-servers/
fi

cat "$here/templates/apache-php.conf" | sed "s/VERSION/$version/g" > "/etc/apache2/cgi-servers/php-$version.conf"

echo -e "\nAdd this line to Virtualhost configuration"
echo -e "\nInclude /etc/apache2/cgi-servers/php-$version.conf"
echo -e "\nAnd restart Apache"

echo -e "\nFinished\n\n"

exit 0
