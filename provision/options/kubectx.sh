#!/usr/bin/env bash

echo "## Installing kubectx"

curl -LO https://github.com/ahmetb/kubectx/releases/download/v0.9.3/kubectx
chmod +x ./kubectx
sudo mv ./kubectx /usr/local/bin/kubectx
