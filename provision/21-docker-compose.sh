#!/usr/bin/env bash
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
docker-compose --version | grep "docker-compose version $DOCKER_COMPOSE_VERSION"
VERSION_MATCH=$?
if [ "$VERSION_MATCH" != "0" ]; then
    echo "## Installation de docker-Compose $DOCKER_COMPOSE_VERSION"

    curl -sL -o ./docker-compose https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`
    mv ./docker-compose /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    curl -sL https://raw.githubusercontent.com/docker/compose/${DOCKER_COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
else
    echo "## docker-compose $DOCKER_COMPOSE_VERSION est déjà installé"
fi