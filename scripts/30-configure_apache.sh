#!/bin/bash -x
echo 'Ejecutando: configure_apache.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: set a defaults
if [ -z "$WEBSERVER_PORT" ]; then
  WEBSERVER_PORT='80'
fi

# change listen port
$SUDO sed -i.bak "s/^Listen .*/Listen ${WEBSERVER_PORT}/" /etc/httpd/conf/httpd.conf
egrep '^Listen=' /etc/httpd/conf/httpd.conf

# rationale: start service
$SUDO systemctl restart httpd.service
