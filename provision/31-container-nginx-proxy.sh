#!/bin/bash

echo "## Mise en place du container nginx-proxy"
docker network create nginx-proxy
docker run -d -p 80:80 --restart unless-stopped --net nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock:ro --name nginx-proxy jwilder/nginx-proxy