apt-get install -y libyaml-dev

for version in $(cat ./versions.txt); do
(
	mkdir -p ./src/; cd ./src/

	git clone https://github.com/php/pecl-file_formats-yaml.git ./php-yaml
	cd ./php-yaml && git checkout php7

	( phpize-$version && ./configure --with-php-config=/opt/phpfarm/inst/bin/php-config-$version --disable-memcached-sasl && make && make install && make clean )
#  echo 'extension=yaml.so' > /etc/php/conf.d/yaml.ini \
)
done
