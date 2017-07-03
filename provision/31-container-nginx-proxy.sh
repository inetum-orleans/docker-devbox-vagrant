#!/bin/bash
if [ ! "$(docker ps -a | grep nginx-proxy)" ]; then
    echo "## Création du container nginx-proxy"

    if [ ! "$(docker network list | grep nginx-proxy)" ]; then
        echo "## Création du network nginx-proxy"
        docker network create nginx-proxy
    else
        echo "## Le network nginx-proxy existe déja"
    fi

    # Ce dossier permet de personnaliser la configuration de chaque virtualhost
    # Voir documentation https://github.com/jwilder/nginx-proxy#custom-nginx-configuration
    mkdir -p /home/ubuntu/.nginx-proxy/vhost.d
    touch /home/ubuntu/.nginx-proxy/my_proxy.conf
    chown -R ubuntu:ubuntu /home/ubuntu/.nginx-proxy

    docker run -d -p 80:80 --restart unless-stopped --net nginx-proxy --name nginx-proxy \
      -v /home/ubuntu/.nginx-proxy/my_proxy.conf:/etc/nginx/conf.d/my_proxy.conf:ro \
      -v /home/ubuntu/.nginx-proxy/vhost.d:/etc/nginx/vhost.d:ro \
      -v /var/run/docker.sock:/tmp/docker.sock:ro \
      jwilder/nginx-proxy
else
    echo "## Le container nginx-proxy existe déja"
fi
