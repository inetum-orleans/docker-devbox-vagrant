# Docker Devbox

Docker devbox is a Vagrant project including everything required to implement docker development environments on 
Windows & Mac.

## Why is that needed ?

Docker for Windows and Docker Toolbox are using VirtualBox/Hyper-V between the Windows host and the Linux VM where the Docker Daemon runs and creates local volumes inside the container. It raises several issues such as :

* Low performances;
* Bad and complicated permissions system;
* Lack of symbolic links that leads to issues for apps.

## Solution

- Oracle virtual machine (Ubuntu)
- Vagrant : provision your virtual machine, including Docker and Docker Compose.
- Traefik : acts as a reverse proxy to resolve local DNS to your web projects.
- Mutagen : synchronizes your Windows workspace with your virtual machine.
- CloudFlareSSL : generates SSL certificates.
- Portainer : manages your Docker images, containers, volumes and networks.
- [Smartcd](https://github.com/cxreg/smartcd) (Aliases auto (dis)Enabling when browsing the filesystem)

## Prerequisites
- Windows > 10
- RAM 16 Go minimum
- SSD with 60 Go free

## Installation guides

[English](docs/README.en.md)

[Français](docs/README.fr.md)
