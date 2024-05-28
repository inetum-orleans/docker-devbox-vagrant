#!/usr/bin/env bash

echo "## Installing AWS CLI"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
if [[ ! -x $(command -v aws) ]]; then
  sudo ./aws/install
else
  sudo ./aws/install --update
fi
rm -rf aws awscliv2.zip