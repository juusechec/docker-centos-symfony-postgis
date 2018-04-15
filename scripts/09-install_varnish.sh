#!/bin/bash
echo 'Ejecutando: install_varnish.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: verificando instalacion varnish
if varnishd -V &> /dev/null
then
  echo 'Varnish ya está instalado, nada que hacer.'
else
  $SUDO yum install -y epel-release
  $SUDO yum install -y varnish
  $SUDO systemctl enable varnish
fi

# rationale: verificando instalacion varnish
file=/etc/varnish/varnish.params
if egrep '^VARNISH_LISTEN_PORT=80' $file &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  $SUDO sed -i.bak 's/^VARNISH_LISTEN_PORT=.*/VARNISH_LISTEN_PORT=80/' $file
fi

# rationale: verificando instalacion varnish
file=/etc/varnish/default.vcl
if egrep '.*.port = "8080";' $file &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  $SUDO sed -i.bak 's/.port =.*/.port = "8080";/' $file
fi

systemctl start varnish
