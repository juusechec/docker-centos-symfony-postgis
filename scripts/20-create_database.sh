#!/bin/bash -x
echo 'Ejecutando: create_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: set a defaults
if [ -z "$DATABASE_PORT" ]; then
  DATABASE_PORT='5432'
fi

# rationale: set a defaults
if [ -z "$DATABASE_NAME" ]; then
  DATABASE_NAME='db_name'
fi

# rationale: set a defaults
if [ -z "$DATABASE_USER" ]; then
  DATABASE_USER='db_user'
fi

# rationale: set a defaults
if [ -z "$DATABASE_PASSWORD" ]; then
  DATABASE_PASSWORD='db_password'
fi

# rationale: check created db
if $SUDO su postgres -c "psql -p ${DATABASE_PORT} -l" | grep "^ ${DATABASE_NAME}\b" &>/dev/null
then
  echo 'La base de datos ya está creada. Nada que hacer.'
else
  # rationale: crear script de creación de la base de datos
  file=/tmp/create_database.sql
  if [ -f $file ]
  then
    echo "El archivo $file ya existe. Nada que hacer."
  else
    $SUDO tee "$file" << EOF
DROP ROLE IF EXISTS ${DATABASE_USER};
CREATE ROLE ${DATABASE_USER} WITH
        INHERIT
        LOGIN
        ENCRYPTED PASSWORD '${DATABASE_PASSWORD}';

DROP DATABASE IF EXISTS ${DATABASE_NAME};
CREATE DATABASE ${DATABASE_NAME}
        ENCODING = 'UTF8'
--        LC_COLLATE = 'en_US.UTF8'
--        LC_CTYPE = 'en_US.UTF8'
        TABLESPACE = pg_default
        OWNER = ${DATABASE_USER};

-- INSTALLING POSTGIS EXTENSION
\connect ${DATABASE_NAME};
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
--CREATE EXTENSION ogr_fdw;
SELECT postgis_full_version();
EOF
  fi
  $SUDO chown postgres:postgres "$file"
  $SUDO su postgres -c "psql ${DATABASE_PORT} -f $file"
fi
