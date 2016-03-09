#!/bin/bash

ver="7.0.4"
(
mkdir ./php-$ver
cd ./php-$ver

git clone https://git.php.net/repository/php-src.git --depth 1 --branch master --single-branch .
#git branch phpng origin/phpng
#git checkout phpng
#git pull
./buildconf

# Compiling PHP with Bison 2.7+
#sed -i -r 's/(bison_version_list=.*)"/\1 2.7 3.0"/' configure
# Compiling PHP with Bison x.y.any.version.scheme.your.distro.want
#sed -i -r "s;(bison_version_vars=.*)/ /'(.*);\1/ /g\2;" configure

#bison_version_exclude="3.0"
sed -i -r 's/(bison_version_exclude=").*"/\1 none"/' configure

)

./compile.sh $ver
