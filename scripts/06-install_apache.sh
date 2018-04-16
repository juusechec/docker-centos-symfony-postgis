#!/bin/bash -x
echo 'Ejecutando: install_apache.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: verificando instalacion apache
if httpd -v &> /dev/null
then
  echo 'HTTPD ya está instalado, nada que hacer.'
else
  $SUDO yum install -y httpd
  $SUDO systemctl enable httpd.service
  # change listen port
  #$SUDO sed -i.bak 's/^Listen .*/Listen 8008/' /etc/httpd/conf/httpd.conf
  #egrep '^Listen=' /etc/httpd/conf/httpd.conf
fi

# rationale: configurar symfony como raiz de apache
file=/etc/httpd/conf.d/30-application.conf
if [ -f $file ]
then
  echo "El archivo $file ya existe. Nada que hacer."
else
  $SUDO tee $file << 'EOF'
Alias "/" "/app/"
<Directory "/app/">
    Options Indexes FollowSymlinks MultiViews
    AllowOverride All
    Require all granted
</Directory>
EOF
fi

# rationale: dar permisos al servidor web para acceder como usuario apache U otro
file=/etc/httpd/conf.d/40-permisos.conf
if [ -f $file ]
then
  echo "El archivo $file ya existe. Nada que hacer."
else
  $SUDO tee $file << 'EOF'
User apache
Group apache
EOF
fi

# rationale: configurar rutas de status e info
# el indice 00- hace que cargue de primero alfabéticamente
file=/etc/httpd/conf.d/50-status.conf
if [ -f $file ]
then
  echo "El archivo $file ya existe. Nada que hacer."
else
  $SUDO tee $file << 'EOF'
Alias "/server-status" "/var/www/dummy"
Alias "/server-info" "/var/www/dummy"
ExtendedStatus on
<Location /server-status>
    SetHandler server-status
    Order deny,allow
    Deny from all
    Allow from all
</Location>
<Location /server-info>
    SetHandler server-info
    Order deny,allow
    Deny from all
    Allow from all
</Location>
EOF
fi

# rationale: iniciar apache
#$SUDO systemctl start httpd
