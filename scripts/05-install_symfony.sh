#!/bin/bash -x
echo 'Ejecutando: install_symfony.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: instalar repositorio webtatic para tener php7 en centos7
if yum -C repolist | grep -i webtatic &> /dev/null
then
  echo 'Webtatic ya está instalado. Nada que hacer.'
else
  $SUDO rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
fi

# rationale: instalar php7.1
# link: https://webtatic.com/packages/php71/
list=(php71w-cli mod_php71w php71w-pgsql php71w-xml php71w-pdo php71w-gd \
  php71w-opcache php71w-cli php71w-intl)
install=installed
for p in ${list[*]}
do
  if yum list installed "$p" &>/dev/null
  then
    echo "$p ya está instalado."
  else
    install=no_installed
  fi
done

if [ "$install" = "installed" ]
then
  echo 'PHP y dependencias de Symfony ya están instalados. Nada que hacer.'
else
  $SUDO yum install -y ${list[*]}
fi

if [ -f /usr/local/bin/symfony ]
then
  echo 'Symfony ya está instalado. Nada que hacer.'
else
  $SUDO mkdir -p /usr/local/bin
  $SUDO curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
  $SUDO chmod a+x /usr/local/bin/symfony
fi

#link: http://stackoverflow.com/a/11695165/4922405
if [ -f /etc/php.ini.bak ]
then
  echo 'php.ini.bak ya existe. Nada que hacer.'
else
  sudo sed -i.bak '/^;date.timezone =$/s:$:\ndate.timezone = "America/Bogota";:' /etc/php.ini
fi
