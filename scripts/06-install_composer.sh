#!/bin/bash -x
echo 'Ejecutando: install_composer.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

if [ -f /usr/local/bin/composer ]
then
  echo 'Composer ya está instalado. Nada que hacer.'
else
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  $SUDO mv composer.phar /usr/local/bin/composer
fi
