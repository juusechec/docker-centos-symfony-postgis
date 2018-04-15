#!/bin/bash -x
echo 'Ejecutando: install_utilities.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

list=(vim git nmap tree wget)
install=installed
for p in ${list[*]}
do
  if which "$p" &>/dev/null
  then
    echo "$p ya está instalado."
  else
    install=no_installed
  fi
done

if [ "$install" = "installed" ]
then
  echo 'Utilities ya están instalados. Nada que hacer.'
else
  $SUDO yum install -y ${list[*]}
fi
