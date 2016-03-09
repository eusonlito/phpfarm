apt-get install -y libgeoip-dev

for version in $(cat ./versions.txt); do
(
	mkdir -p ./src/; cd ./src/

	svn co http://svn.php.net/repository/pecl/geoip/trunk ./php-geoip
	cd ./php-geoip

	(
		phpize-$version && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$version \
		&& make && make install && make clean \
		&& echo 'extension=geoip.so' >> /opt/phpfarm/inst/php-$version/lib/php.ini
	)
)
done
