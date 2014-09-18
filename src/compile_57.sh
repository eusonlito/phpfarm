#!/bin/bash

(
mkdir ./php-5.7.0-dev
cd ./php-5.7.0-dev

git clone https://git.php.net/repository/php-src.git .
git branch phpng origin/phpng
git checkout phpng
./buildconf
)

./compile.sh 5.7.0-dev
