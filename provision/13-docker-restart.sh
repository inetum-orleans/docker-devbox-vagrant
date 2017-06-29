#!/bin/bash

echo "## Rechargement du daemon"
sudo systemctl daemon-reload

echo "## Restart de Docker"
sudo systemctl restart docker