#!/bin/bash -eux

# Do some stuffs
echo "Hello, I'm example"
echo "I can run optionally"

cat << 'EOF'
# ¿Cómo ejecutar scripts de población de base de datos con el usuario postgres?

SQL_OUTSIDE_DB=/tmp/sql_outside_db.sql
SQL_INSIDE_DB=/tmp/sql_inside_db.sql
DB_NAME=example_db

if echo 'SELECT * FROM public.parametro;' | $SUDO psql -U postgres -d ${DB_NAME} &>/dev/null
then
  echo 'La tabla parametro ya está creada. Nada que hacer.'
elif echo "\connect ${DB_NAME};" | $SUDO psql -U postgres&>/dev/null
then
  echo 'La base de datos ya está creada. Nada que hacer.'
else
$SUDO chown postgres:postgres ${SQL_OUTSIDE_DB} ${SQL_INSIDE_DB}
$SUDO su postgres -c "
cd /tmp
psql -p 5432 -f ${SQL_OUTSIDE_DB}
psql -p 5432 -f ${SQL_INSIDE_DB} -d ${DB_NAME}
"
fi
EOF
