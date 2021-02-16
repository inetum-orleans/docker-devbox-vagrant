#!/usr/bin/env bash
echo "## Installation de docker-devbox"
curl -sL https://github.com/gfi-centre-ouest/docker-devbox/raw/master/installer | DOCKER_DEVBOX_LEGACY=1 bash

mkdir -p "$HOME/projects"
