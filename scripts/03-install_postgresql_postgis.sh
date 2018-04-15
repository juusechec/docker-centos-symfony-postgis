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
$SUDO /usr/pgsql-9.5/bin/postgresql95-setup initdb
$SUDO systemctl enable postgresql-9.5
$SUDO sed -i.bak "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/9.5/data/postgresql.conf
$SUDO sed -i.bak 's/peer/trust/; s/ident/md5/' /var/lib/pgsql/9.5/data/pg_hba.conf
$SUDO tee -a /var/lib/pgsql/9.5/data/pg_hba.conf << 'EOF'
host    all             all             0.0.0.0/0               md5
EOF
$SUDO systemctl start postgresql-9.5.service
echo "Se ha terminado la instalación de Postgresql"
#if you what remove # yum erase postgresql95*
cat << 'EOF'
# ¿Cómo crear un usuario y una base de datos?
$ sudo su postgres
$ psql
> CREATE USER nombre_usuario WITH PASSWORD 'clave';
> CREATE DATABASE nombre_db WITH OWNER = nombre_usuario ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;
> ALTER USER nombre_usuario WITH ENCRYPTED PASSWORD 'clave'; --CHANGE USER PASSWORD
$ vim /var/lib/pgsql/9.5/data/pg_hba.conf
#host   DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust
host    all             all             127.0.0.1/32            md5
host    all             all             localhost               md5
host    all             all             0.0.0.0/0               md5
host    all             all             ::1/128                 md5#sara
$ $SUDO systemctl restart postgresql-9.5.service
EOF
echo "Instalando Postgis"
$SUDO yum install -y epel-release
$SUDO yum install -y postgis2_95
echo "Postgis Instalado"
cat << 'EOF'
# ¿Cómo instalar postgis en tu base de datos?
$ $SUDO su postgres
$ /usr/pgsql-9.5/bin/psql -p 5432
> CREATE DATABASE gistest;
> \connect gistest;
> CREATE EXTENSION postgis;
> CREATE EXTENSION postgis_topology;
> CREATE EXTENSION ogr_fdw;
> SELECT postgis_full_version();
EOF
fi
