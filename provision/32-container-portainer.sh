#!/bin/bash

if [ ! "$(docker ps -a | grep portainer)" ]; then
    echo "## Création du container portainer"

    docker run -d -p 9000:9000 \
        --restart unless-stopped \
        --name portainer \
        -v /var/run/docker.sock:/var/run/docker.sock \
        portainer/portainer \
        -H unix:///var/run/docker.sock \
        --no-auth
else
    echo "## Le container portainer existe déja."
fi
