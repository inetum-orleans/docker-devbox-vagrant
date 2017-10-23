#!/bin/bash

echo "## Installation des certificats CA SSL"
mkdir -p /usr/local/share/ca-certificates
rm -f /usr/local/share/ca-certificates/*

for f in "/home/ubuntu/.provision/ca-certificates/*"
do
  ln -rs $f /usr/local/share/ca-certificates/
  mv "`basename "$f"`" "`basename "$f" .pem`.crt"
done

cd /usr/local/share/ca-certificates/
for f in *.pem; do
    mv "$f" "`basename "$f" .pem`.crt"
done

update-ca-certificates

