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
  ``git clone git@github.com:yfix/phpfarm.git phpfarm``
- ``cd phpfarm/src/``
- ``./compile.sh 5.6.14``
- PHP gets installed into ``phpfarm/inst/php-$version/``
- ``phpfarm/inst/bin/php-$version`` is also executable.
  You should add ``inst/bin`` to your ``$PATH``, i.e.
  ``PATH="$PATH:$HOME/phpfarm/inst/bin"`` in ``.bashrc``,
  as well as ``inst/current-bin``.


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
