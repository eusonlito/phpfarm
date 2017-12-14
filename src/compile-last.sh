#!/bin/bash

FORCE=
TARGETED_VERSION=
LAST_AVAILABLE_VERSION=


function usage() {
    cat << EOF
This script compile the last version of php.

USAGE: [OPTION] ... [PHPVERSION]

OPTIONS:
    -h                      show help
    -f                      compile without confirmation.
    -s|show                 only show the last complete php version available for targeted version.

example of use:
./compile-last.sh -s 5.6 : show last php version available for php5.6.
./compile-last.sh -f 5.6 : compile php without confirmation message.
EOF
}

while getopts ":hfs" OPTION
do
    case $OPTION in
        h|help)
            usage
            exit 1
            echo "1"
            ;;
        f)
            FORCE=1
            ;;
        s|show)
            LAST_AVAILABLE_VERSION=1
            ;;
        \?)
            echo -e "\033[31mInvalid option : -${OPTARG}\033[0m\n"
            usage
            exit
            ;;

        :)
            echo -e "\033[31mAn argument is required for option -${OPTARG}\033[0m\n"
            usage
            exit
            ;;
     esac
done

shift $(($OPTIND-1))
TARGETED_VERSION="$1"


if [ -z "$TARGETED_VERSION" ];
then
    echo $TARGETED_VERSION;
    usage
    echo -e "\nYou must pass the PHP group version 5.5 / 5.6 / 7.0\n"
    exit 1
fi

prefix="$(echo "$TARGETED_VERSION" | sed 's/\./\\\./')"
version="$(curl -s "https://secure.php.net/releases/" | grep -o -m 1 '"'$prefix'\.[0-9]\+"' | awk -F'"' '{print $2}')"

if [ "$version" == "" ]; then
    echo -e "\nNo version found starting with $1 \n"
    exit 1
fi

if [[ "$LAST_AVAILABLE_VERSION" == 1 ]]
then
  echo -e "$version"
  exit 1
fi


if [[ -z "$FORCE" ]]
then
  read -p "Last version from PHP releases website is $version - Install it? [y/n] " response

  if [ "$response" != "y" ]; then
      echo -e "\nCanceled\n"
      exit 1
  fi
fi

if [ ! -f "custom-options-$version.sh" ]; then
    if [[ -z "$FORCE" ]]
    then
      read -p "There aren't a custom-options-$version.sh file. Use default options from custom-options-default.sh? [y/n] " custom
      if [ "$custom" == "y" ]; then
          cp -p "custom-options-default.sh" "custom-options-$version.sh"
      fi
    else
      cp -p "custom-options-default.sh" "custom-options-$version.sh"
    fi
fi

if [ ! -f "default-custom-php.ini" ]; then
    if [ -f /etc/timezone ]; then
        echo 'date.timezone="'$(cat /etc/timezone)'"' >> default-custom-php.ini
    fi

    echo 'include_path=".:/opt/phpfarm/inst/php-'$version'/pear/php/"' >> default-custom-php.ini
fi

./compile.sh $version

exit 0