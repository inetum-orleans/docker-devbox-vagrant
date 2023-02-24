#!/usr/bin/env bash

echo "## Installing Openjdk"
sudo apt update && apt upgrade -y
sudo apt install default-jdk -y