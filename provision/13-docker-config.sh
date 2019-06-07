#!/usr/bin/env bash

echo "## Ajout de l'utilisateur $USER au groupe docker"
getent group docker || groupadd docker
usermod -aG docker $USER

IP_ADDRESS=`ip addr show enp0s8 | grep 'inet ' | awk '{ print $2}' | cut -d'/' -f1`

echo "## Configuration de l'écoute sur tcp://$IP_ADDRESS:2375"
mkdir -p /etc/systemd/system/docker.service.d

cat << EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix:// -H tcp://$IP_ADDRESS:2375 -H tcp://127.0.0.1:2375
EOF

echo "## Rechargement du daemon"
systemctl daemon-reload

echo "## Restart de Docker"
systemctl restart docker