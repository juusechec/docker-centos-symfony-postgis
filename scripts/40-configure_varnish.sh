#!/bin/bash -x
echo 'Ejecutando: configure_varnish.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: set a defaults
if [ -z "$VARNISH_PORT" ]; then
  VARNISH_PORT='80'
fi

# rationale: set a defaults
if [ -z "$WEBSERVER_PORT" ]; then
  WEBSERVER_PORT='8080'
fi

# rationale: verificando instalacion varnish
file=/etc/varnish/varnish.params
if egrep "^VARNISH_LISTEN_PORT=${VARNISH_PORT}" "$file" &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  $SUDO sed -i.bak "s/^VARNISH_LISTEN_PORT=.*/VARNISH_LISTEN_PORT=${VARNISH_PORT}/" "$file"
fi

# rationale: verificando instalacion varnish
file=/etc/varnish/default.vcl
if egrep ".*.port = \"${WEBSERVER_PORT}\";" "$file" &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  $SUDO sed -i.bak "s/.port =.*/.port = \"${WEBSERVER_PORT}\";/" "$file"
fi

# rationale: start service
$SUDO systemctl restart varnish.service
