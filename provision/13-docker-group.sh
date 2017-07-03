#!/bin/bash

echo "## Ajout de l'utilisateur au groupe docker"
getent group docker || groupadd docker
usermod -aG docker ubuntu

echo "## Rechargement du daemon"
systemctl daemon-reload

echo "## Restart de Docker"
systemctl restart docker