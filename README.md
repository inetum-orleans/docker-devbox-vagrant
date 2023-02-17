# Docker Devbox

Docker devbox is a Vagrant project including everything required to implement docker development environments on 
Windows & Mac.

## Why is that needed ?

Docker for Windows and Docker Toolbox are using VirtualBox/Hyper-V between the Windows host and the Linux VM where the Docker Daemon runs and creates local volumes inside the container. It raises several issues such as :

* Low performances;
* Bad and complicated permissions system;
* Lack of symbolic links that leads to issues for apps.

## Solution

* Docker VM (Ubuntu Xenial).
* Provisionning Docker, Docker-Compose and nginx-proxy using Vagrant.
* [nfs4j-daemon](https://github.com/inetum-orleans/nfs4j-daemon) to share files between the Windows host and the Docker VM.
* [Smartcd](https://github.com/cxreg/smartcd) (Aliases auto (dis)Enabling when browsing the filesystem)

This solution is built from scratch in order to keep agile on the environment.

*Note:  nginx-proxy allows to connect to a web container through `http://my-app.test` instead of `http://192.168.1.100:<port>`*.

## Prerequisites

- [VirtualBox](https://www.virtualbox.org/) (**/!\\** Virtualisation must be enabled in BIOS.)
- [Vagrant](https://www.vagrantup.com/)
- [Vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) (`vagrant plugin install vagrant-vbguest`)
- [Vagrant-nfs4j](https://github.com/inetum-orleans/vagrant-nfs4j) (`vagrant plugin install vagrant-nfs4j`)
- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize) (`vagrant plugin install vagrant-disksize`)
- [vagrant-certificates](https://github.com/inetum-orleans/vagrant-certificates) (Optional, `vagrant plugin install vagrant-certificates`)
- [vagrant-persistent-storage](https://github.com/kusnier/vagrant-persistent-storage) (Optional, `vagrant plugin install vagrant-persistent-storage`)
- [Acrylic DNS Proxy](https://sourceforge.net/projects/acrylic) (Optional, [Intallation guide on StackOverflow](https://stackoverflow.com/questions/138162/wildcards-in-a-windows-hosts-file#answer-9695861), DNS local proxy to redirect `*.test` to 
the docker environment. Same as for the `/etc/hosts` file but also allows wildcards `*`)

## Installation

- Clone the repository

```bash
git clone https://github.com/inetum-orleans/docker-devbox-vagrant
cd docker-devbox-vagrant
```

- Run Vagrant:

```bash
vagrant up
```

When running the `ubuntu/xenial` box for the first time, the image is downloaded and then provisionned as defined in the Vagrantfile.
The Vagrantfile is provisionning using the scripts located in the `provision` folder.

Once the VM is provisionned, you can access to it through:

```bash
vagrant ssh
```

The `docker` and `docker-compose` are available there.

## Setup

The VM can be configured by editing the `config.yaml` file. Just use the `config.example.yaml` modify it and save it as `config.yaml`.

## Git configuration (Host and VM)

* Use your first and last name and GFI mail.

```bash
git config --global user.name "Fisrt Last"
git config --global user.email "first.last@gfi.fr"
```

* To avoid flowding the commit history with merge commits.

```bash
git config --global pull.rebase true
```

## Configure carriage return

To avoid problems sharing file between Windows and Linux, it is usefull to do these things :

- Parameter git `core.autocrlf false` option.

```bash
git config --global core.autocrlf false
```

- Use the (LF) carriage return only with your editor. (Linux norm)

## Optionnal conf of Acrylic DNS Proxy

Acrylic DNS Proxy is used to route sets of DN to the VM without having to modify the `/etc/hosts` file.

- Define the DNS server IP to IPv4: `127.0.0.1`, and IPv6: `::1` in the network interface.

- Start Menu > Edit Acrylic Configuration File > Modify the following parameters:

```
PrimaryServerAddress=172.16.78.251
SecondaryServerAddress=10.45.6.3
TertiaryServerAddress=10.45.6.2
```

- Start Menu > Edit Acrylic Hosts File > Add this line at the end of the file:

```
192.168.1.100 *.test
```

## Vagrant cheatsheet

- Run VM

```bash
vagrant up
```

- Stop VM
```bash
vagrant halt
```

- Reboot VM
```bash
vagrant reload
```

- Create VM
```bash
vagrant provision
```

## Automated installation of CA certificates

`vagrant-certificates` can install CA Certificates automatically on VM certificates located in a directory of the host.

## Synchronisation of project files through NFS

A NFS mounting-point can be used through the plugin `vagrant-nfs4j`.

You must edit the `synced_folder` section in the `config.yaml` file as described in the **Setup** section.

```yml
synced_folders:
  user:
    source: 'C:\Users\user' # absolute or relative path from Vagrantfile
    target: '/C/Users/user' # absolute or relative path from home of VM
  projects:
    source: 'C:\devel\projects' # absolute or relative path from Vagrantfile
    target: '/C/devel/projects' # absolute or relative path from home of VM
```

Once the `synced_folders` section is filled, Vagrant will automatically launch nfs4j-daemon to mount specified files using NFS.

To use symbolic links, you should configure [Local Group Policy to allow symbolic links creation](https://github.com/inetum-orleans/nfs4j-daemon#symbolic-links-support-on-windows) 
for your user.

### Free the diskspace

Be aware that `dc down` destroy the containers! Please stop the containers (`dc stop`) to save the volumes before destroying them.

 ```
 docker system prune --filter "until=24h"
 docker image prune
 ```

 ### VPN Issues

If the vpnc client can't reach connect, you must check the network interfaces MTU (1500).

See [https://www.virtualbox.org/ticket/13847](https://www.virtualbox.org/ticket/13847)

### User interface PORTAINER

A user interface is available in order to manage containers/volumes. Reachable at : `portainer.test` (should be added in the host machine hosts file if needed).
It is based on [PORTAINER](https://portainer.readthedocs.io/en/stable/index.html)