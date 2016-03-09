apt-get install -y libmemcached-dev

for version in $(cat ./versions.txt); do
(
	mkdir -p ./src/; cd ./src/

	git clone https://github.com/php-memcached-dev/php-memcached.git ./php-memcached
  	cd ./php-memcached && git checkout php7

	( phpize-$version && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$version --disable-memcached-sasl && make && make install && make clean )
#	echo 'extension=memcached.so' > /etc/php/conf.d/memcached.ini \
)
done