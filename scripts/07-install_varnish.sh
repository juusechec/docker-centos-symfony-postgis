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
  $SUDO systemctl enable varnish.service
fi

# rationale: iniciar varnish
#systemctl start varnish
