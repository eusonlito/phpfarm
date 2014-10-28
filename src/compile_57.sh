#!/bin/bash

ver="5.7.0"
(
mkdir ./php-$ver
cd ./php-$ver

git clone https://git.php.net/repository/php-src.git --depth 1 --branch phpng --single-branch .
#git branch phpng origin/phpng
#git checkout phpng
#git pull
./buildconf
)

./compile.sh $ver
