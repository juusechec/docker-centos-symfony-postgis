#!/bin/bash -x
echo 'Ejecutando: install_postgresql_postgis.sh'

# rationale: set a default $SUDO
if [ -z "$SUDO" ]; then
  SUDO=''
fi

if [ -f /usr/pgsql-9.5/bin/pg_ctl ]; then
  echo 'Postgres ya está instalado. Nada que hacer.'
else
  echo "Instalando PostgreSQL"
  $SUDO yum localinstall -y http://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7.3-x86_64/pgdg-centos95-9.5-3.noarch.rpm
  $SUDO yum install -y postgresql95-server
  $SUDO systemctl enable postgresql-9.5.service
  echo "Se ha terminado la instalación de Postgresql"

  echo "Instalando Postgis"
  $SUDO yum install -y epel-release
  $SUDO yum install -y postgis2_95
  echo "Postgis Instalado"
fi
