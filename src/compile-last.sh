#!/bin/bash

if [ "$1" == "" ]; then
    echo -e "\nYou must pass the PHP group version 5.5 / 5.6 / 7.0\n"
    exit 1
fi

prefix="$(echo "$1" | sed 's/\./\\\./')"
version="$(curl -s "https://secure.php.net/releases/" | grep -o -m 1 '"'$prefix'\.[0-9]\+"' | awk -F'"' '{print $2}')"

if [ "$version" == "" ]; then
    echo -e "\nNo version found starting with $1 \n"
    exit 1
fi

echo ""

read -p "Last version from PHP releases website is $version - Install it? [y/n] " response

if [ "$response" != "y" ]; then
    echo -e "\nCanceled\n"
    exit 1
fi

echo ""

if [ ! -f "custom-options-$version.sh" ]; then
    read -p "There aren't a custom-options-$version.sh file. Use default options from custom-options-default.sh? [y/n] " custom

    if [ "$custom" == "y" ]; then
        cp -p "custom-options-default.sh" "custom-options-$version.sh"
    fi
fi

if [ ! -f "default-custom-php.ini" ]; then
    if [ -f /etc/timezone ]; then
        echo 'date.timezone="'$(cat /etc/timezone)'"' >> default-custom-php.ini
    fi

    echo 'include_path=".:/opt/phpfarm/inst/php-'$version'/pear/php/"' >> default-custom-php.ini
fi

./compile.sh $version

exit 0