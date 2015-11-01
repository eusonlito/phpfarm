(
	mkdir -p ./src/
	cd ./src/
	pecl download memcache
	tar -xvzf ./memcache-*.tgz
	cd ./memcache-*

	( phpize-5.3.29 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.3.29 && make && make install && make clean )
	( phpize-5.4.34 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.4.34 && make && make install && make clean )
	( phpize-5.6.2 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.6.2 && make && make install && make clean )
	( phpize-5.7.0 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.7.0 && make && make install && make clean )
)