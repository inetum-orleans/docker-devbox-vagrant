#!/bin/bash
echo "## Configuration des paramètres système"

echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p