#!/bin/bash

# Ce script doit être lancé avec l'utilisateur ubuntu (Utiliser privileged: false dans Vagrantfile)

echo "## Configuration des variables d'environnement"

echo "HOST_IP: ${HOST_IP} (Adresse IP de l'hôte)"

if grep -q "HOST_IP=" "${HOME}/.profile"; then
  sed -i "s/.*HOST_IP=.*/export HOST_IP=${HOST_IP}/" "${HOME}/.profile"
else
  echo -e>>"${HOME}/.profile"
  echo "# Host IP Address">>"${HOME}/.profile"
  echo "export HOST_IP=${HOST_IP}">>"${HOME}/.profile"
fi
