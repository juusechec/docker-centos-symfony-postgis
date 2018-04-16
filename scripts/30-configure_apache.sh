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

# rationale: set a defaults
if [ -z "$WEBSERVER_PATH" ]; then
  WEBSERVER_PATH='/htdocs/'
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

# change path
file=/etc/httpd/conf.d/30-application.conf
if egrep "<Directory \"${WEBSERVER_PATH}\">" "$file" &> /dev/null
then
  echo "$file ya está configurado, nada que hacer."
else
  # rationale: I can change / with # for URL of PATHS
  # link: https://stackoverflow.com/questions/22182050/sed-e-expression-1-char-23-unknown-option-to-s
  $SUDO sed -i.bak "s#^Alias \"/\" .*#Alias \"/\" \"${WEBSERVER_PATH}\"#" "$file"
  $SUDO sed -i "s#^<Directory .*#<Directory \"${WEBSERVER_PATH}\">#" "$file"
  grep "${WEBSERVER_PATH}" "$file"
fi


# rationale: start service
$SUDO systemctl restart httpd.service
