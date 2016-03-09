for version in $(cat ./versions.txt); do
(
	mkdir -p ./src/; cd ./src/

	git clone https://github.com/phpredis/phpredis.git ./php-redis
	cd ./php-redis && git checkout php7

	(
		phpize-$version && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$version \
		&& make && make install && make clean \
		&& echo 'extension=redis.so' >> /opt/phpfarm/inst/php-$version/lib/php.ini
	)
)
done
