apt-get install -y libmagickwand-dev

for version in $(cat ./versions.txt); do
(
	mkdir -p ./src/; cd ./src/

	git clone https://github.com/mkoppanen/imagick.git ./php-imagick
	cd ./php-imagick && git checkout phpseven

	( phpize-$version && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$version && make && make install && make clean )
#  echo 'extension=imagick.so' > /etc/php/conf.d/imagick.ini \
)
done
