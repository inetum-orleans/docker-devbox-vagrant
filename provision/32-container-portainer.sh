#!/bin/bash

echo "## Création du container portainer"

if [ "$(docker ps -a --format '{{.Names}}' | grep portainer)" ]; then
    echo "## Suppression du container existant"
    docker rm -f portainer
fi

docker volume create portainer

docker run -d -p 9000:9000 \
    --restart unless-stopped \
    --name portainer \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer:/data \
    -e "VIRTUAL_HOST=portainer.test" \
    --network="nginx-proxy" \
    portainer/portainer \
    -H unix:///var/run/docker.sock \
    --no-auth
