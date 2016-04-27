phpfarm
=======

Set of scripts to install a dozen of PHP versions in parallel on a system.
It also creates a Pyrus installation for each PHP version.
Primarily developed for PEAR's continuous integration machine.

The PHP source packages are fetched from ``museum.php.net`` (which is not
always up-to-date), the official php.net download pages and the
pre-release channels.
If a file cannot be found, try to fetch it manually and put it into
``src/bzips/``


Setup
-----
- Check out phpfarm from git:
  ``git clone git@github.com:eusonlito/phpfarm.git phpfarm``
- ``cd phpfarm/src/``
- ``./compile.sh 5.6.14``
- PHP gets installed into ``phpfarm/inst/php-$version/``
- ``phpfarm/inst/bin/php-$version`` is also executable.
  You should add ``inst/bin`` to your ``$PATH``, i.e.
  ``PATH="$PATH:$HOME/phpfarm/inst/bin"`` in ``.bashrc``,
  as well as ``inst/current-bin``.

Discover Last PHP version
-------------------------

- ``cd phpfarm/src/``
- ``./compile-last.sh 5.6``

Customization
-------------
Default configuration options are in ``src/options.sh``.
You may create version-specific custom option files:

- ``custom-options.sh``
- ``custom-options-5.sh``
- ``custom-options-5.6.sh``
- ``custom-options-5.6.14.sh``

The shell script needs to define a variable "``$configoptions``" with
all ``./configure`` options.
Do not try to change ``prefix`` and ``exec-prefix``.

``php.ini`` values may also be customized:

- ``custom-php.ini``
- ``custom-php-5.ini``
- ``custom-php-5.6.ini``
- ``custom-php-5.6.14.ini``

Problems with old versions
--------------------------

Compile PHP old version and fails with:

```
/usr/bin/ld: ext/openssl/openssl.o: undefined reference to symbol 'SSL_get_verify_result@@OPENSSL_1.0.0'
//lib/x86_64-linux-gnu/libssl.so.1.0.0: error adding symbols: DSO missing from command line
collect2: error: ld returned 1 exit status
Makefile:258: recipe for target 'sapi/cgi/php-cgi' failed
make: *** [sapi/cgi/php-cgi] Error 1
make failed.
```

Use `compile-old.sh`

- ``cd phpfarm/src/``
- ``./compile-old.sh 5.3.29``

Apache auto-configuration
-------------------------

You can execute this command after PHP compilation.

- ``cd phpfarm/src/``
- ``./install-apache.sh 5.3.29``

Will create:

* /var/www/cgi-bin/ folder with /var/www/cgi-bin/php-cgi-$version wrapper
* /etc/php5/cgi/$version/php.ini configuration file
* /etc/apache2/conf-available/phpfarm.conf apache phpfarm configuration
* /etc/apache2/cgi-servers/php-$version.conf VirtualHost configuration

Finally you only need to add a `Include /etc/apache2/cgi-servers/php-$version.conf` to your VirtualHost configuration.
