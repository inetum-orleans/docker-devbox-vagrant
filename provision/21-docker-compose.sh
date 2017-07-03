#!/bin/bash

echo "## Installation de Docker-Compose"
DOCKER_COMPOSE_VERSION=1.13.0
curl -fsSL -o ./docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`
sudo mv ./docker-compose /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose