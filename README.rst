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

will returns:

```
Last version from PHP releases website is 5.6.19 - Install it? [y/n]
```

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

* ``/var/www/cgi-bin/`` folder with ``/var/www/cgi-bin/php-cgi-$version`` wrapper
* ``/etc/php5/cgi/$version/php.ini`` configuration file
* ``/etc/apache2/conf-available/phpfarm.conf`` apache phpfarm configuration
* ``/etc/apache2/cgi-servers/php-$version.conf`` VirtualHost configuration

Finally you only need to add a ``Include /etc/apache2/cgi-servers/php-$version.conf`` to your VirtualHost configuration.

Compilation errors
------------------

Ubuntu 14.04 common libraries missing.

```
configure: error: Cannot find MySQL header files under /usr/local/mysql.

$> apt-get install -y libmysqlclient-dev

configure: error: Please reinstall the BZip2 distribution

$> apt-get install -y libbz2-dev

configure: error: xml2-config not found. Please check your libxml2 installation.

$> apt-get install -y libxml2-dev

configure: error: bison is required to build PHP/Zend when building a GIT checkout!

$> apt-get install -y bison

configure: error: Cannot find OpenSSL's

$> apt-get install -y libssl-dev

configure: error: Cannot find OpenSSL's libraries

$> apt-get install -y libssl-dev

configure: error: Please reinstall the libcurl distribution easy.h should be in /include/curl/

$> apt-get install -y libcurl4-openssl-dev

configure: error: jpeglib.h not found.

$> apt-get install -y libjpeg-dev

configure: error: png.h not found.

$> apt-get install -y libpng12-dev

configure: error: freetype-config not found.

$> apt-get install -y libfreetype6-dev

configure: error: mcrypt.h not found. Please reinstall libmcrypt.

$> apt-get install -y libmcrypt-dev

configure: error: Cannot find pspell

$> apt-get install -y libpspell-dev

configure: error: Can not find recode.h anywhere under /usr /usr/local /usr /opt.

$> apt-get install -y librecode-dev

configure: error: xslt-config not found. Please reinstall the libxslt >= 1.1.0 distribution

$> apt-get install -y libxslt-dev

configure: error: Cannot find libpq-fe.h. Please specify correct PostgreSQL installation path

# If you haven't PostgreSQL, remove --with-pdo-pgsql and --with-pgsql lines

configure: error: could not find pcre.h in /usr

$> apt-get install -y libpcre3-dev

configure: error: libjpeg.(a|so) not found.

$> apt-get install -y libjpeg-dev

configure: error: libxpm.(a|so) not found.

$> apt-get install -y libxpm-dev

configure: error: unable to locate gmp.h

$> apt-get install -y libgmp-dev
$> ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

configure: error: sasl.h not found!

$> apt-get install -y libsasl2-dev

configure: error: please reinstall libmhash - i cannot find mhash.h

$> apt-get install -f libmhash-dev

configure: error: directory /usr is not a freetds installation directory

$> apt-get install -f freetds-dev

configure: error: cannot find pspell

$> apt-get install libpspell-dev

configure: error: cannot find libtidy

$> apt-get install libtidy-dev
```