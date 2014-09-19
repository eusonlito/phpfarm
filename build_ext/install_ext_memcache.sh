(
	mkdir -p ./src/
	cd ./src/
	pecl download memcache
	tar -xvzf ./memcache-*.tgz
	cd ./memcache-*

#	(phpize-5.3.28 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.3.28 && make && make install && make clean)
	(phpize-5.3.29 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.3.29 && make && make install && make clean)
#	(phpize-5.4.31 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.4.31 && make && make install && make clean)
	(phpize-5.4.32 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.4.32 && make && make install && make clean)
#	(phpize-5.6.0RC3 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.6.0RC3 && make && make install && make clean)
	(phpize-5.6.0 && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-5.6.0 && make && make install && make clean)
)