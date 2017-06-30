#!/bin/bash

echo "## Ajout de l'utilisateur au groupe docker"
sudo getent group docker || sudo groupadd docker
sudo usermod -aG docker $USER

echo "## Rechargement du daemon"
sudo systemctl daemon-reload

echo "## Restart de Docker"
sudo systemctl restart docker