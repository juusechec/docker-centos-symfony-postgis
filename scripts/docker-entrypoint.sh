#!/bin/bash -eux

# Do some stuffs
echo 'Wait for initiation.'

#exec /usr/sbin/init & # To correctly start D-Bus thanks to https://forums.docker.com/t/any-simple-and-safe-way-to-start-services-on-centos7-systemd/5695/8

# rationale: inicia los scripts cuando systemd esté activo
function execScripts {
while ! systemctl status &> /dev/null
do
  sleep 2
  echo "/usr/sbin/init not ready..."
done

echo "/usr/sbin/init ready!"
$SCRIPT_ON_RUN
journalctl -f
}

execScripts &

exec /usr/sbin/init
