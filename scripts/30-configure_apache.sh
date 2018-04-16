#!/bin/bash -x
echo 'Ejecutando: configure_apache.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: set a defaults
if [ -z "$WEBSERVER_PORT" ]; then
  WEBSERVER_PORT='8080'
fi

# change listen port
file=/etc/httpd/conf/httpd.conf
if egrep "^Listen ${WEBSERVER_PORT}" "$file" &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  $SUDO sed -i.bak "s/^Listen .*/Listen ${WEBSERVER_PORT}/" "$file"
  egrep '^Listen=' "$file"
fi

# rationale: start service
$SUDO systemctl restart httpd.service
