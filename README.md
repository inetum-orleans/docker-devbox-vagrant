# Docker sous Vagrant

## Pourquoi ?

Docker for windows et Docker toolbox utilisent des partages VirtualBox/Hyper-V entre l'hôte Windows et la VM Linux ou 
s'execute le daemon docker pour monter le volumes locaux dans le container. Celà entraine une série de problèmes:

- Performance médiocres.
- Droits altérés et difficiles à maitriser.
- Liens symboliques absents provoquant des problèmes pour certains programmes.

## Solution

- VM Docker (Ubuntu Xenial).
- Vagrant pour provisionner Docker, Docker Compose et [nginx-proxy](https://github.com/jwilder/nginx-proxy).
- [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) pour synchroniser les fichiers entre l'hôte sous windows et la VM Docker.
- [Smartcd](https://github.com/cxreg/smartcd) (Activation/Désactivation automatique d'alias lors de l'entrée/sortie dans un dossier)

Cette solution est construite de zéro ce qui nous permet de garder un grand contrôle sur l'environnement technique.

*Note: nginx-proxy permet d'accéder un à container web via `http://monappli.app` plutôt que `http://192.168.1.100:<port>`*

## Pré-requis
- [VirtualBox](https://www.virtualbox.org/) (**/!\\** La virtualisation doit être activé dans le bios de la machine)
- [Vagrant](https://www.vagrantup.com/) (**/!\\** [la version 1.9.7 est buguée](https://github.com/mitchellh/vagrant/issues/8764), utiliser la 1.9.6 présente sur le partage réseau ``S:/Vagrant/vagrant_1.9.6_x86_64.msi``
- [Vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) (`vagrant plugin install vagrant-vbguest`)
- [Vagrant-winnfsd](https://github.com/winnfsd/vagrant-winnfsd) (`vagrant plugin install vagrant-winnfsd`)
- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize) (`vagrant plugin install vagrant-disksize`)
- [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf) (`vagrant plugin install vagrant-proxyconf`)
- [Acrylic DNS Proxy](https://sourceforge.net/projects/acrylic) (Optionnel, [Aide d'installation sur StackOverflow](https://stackoverflow.com/questions/138162/wildcards-in-a-windows-hosts-file#answer-9695861), Proxy DNS local pour rediriger `*.app` vers 
l'environnement docker, identique au fichier `/etc/hosts` mais supporte les wildcard `*`)

## Fork de winnfsd

Pour résoudre un bug de winnfsd (https://github.com/winnfsd/winnfsd/pull/49), il est préférable d'utiliser une version corrigée et recompilée.

Copier le fichier `winnfsd/winnfsd.exe` sur `%USERPROFILE%\.vagrant.d\gems\2.3.4\gems\vagrant-winnfsd-1.3.1\bin`.

## Installation

- Cloner le repository

```bash
git clone http://gitlab/PoleDigital/vagrant-docker.git
cd vagrant-docker
```

- Lancer vagrant:

```bash
vagrant up
```

Au premier lancement, la box `ubuntu/xenial` est téléchargée depuis le cloud Vagrant, puis provisionnée selon la 
définition du Vagrantfile. Le vagrantfile provisionne grâce aux scripts présents dans le dossier `provision`.

Une fois la machine provisionnée, vous pouvez vous connecter à celle-ci via la commande:

```bash
vagrant ssh
```

Les commandes `docker` et `docker-compose` sont disponibles dans cet environnement.

## Paramétrage

Il est possible de paramétrer la VM avec le fichier `config.yaml`. Copier le fichier `config.example.yaml` vers 
`config.yaml`, et modifier selon vos besoins.

## Configuration de git sur la VM et sur la machine hôte

* Utiliser som prénom & nom comme et adresse mail GFI.

```bash
git config --global user.name "Prénom Nom"
git config --global user.email "prenom.nom@gfi.fr"
```

* Pour éviter de polluer l'historique des commits avec des merge commit.

```bash
git config --global pull.rebase true
```

## Configuration des sauts de ligne sur le projet

Pour éviter tout problème lors du partage de fichier entre Linux et Windows, il faut prendre quelques précautions au 
sujet des caractères de saut de lignes.

- Paramétrer l'option pour git `core.autocrlf false`.

```bash
git config --global core.autocrlf false
```

- Paramétrer l'éditeur de code pour utiliser les sauts de ligne linux uniquement (LF).

## Configuration de Acrylic DNS Proxy (optionnel)

Acrylic DNS Proxy permet de router des ensemble de noms de domaines vers la VM, sans avoir à modifier le fichier 
`/etc/hosts` pour chaque projet.

- Dans les propriétés de la carte réseau, définir le serveur DNS de l'interface IPv4 à `127.0.0.1`, et IPv6 à `::1`.

- Menu Démarrer > Edit Acrylic Configuration File > Modifier les paramètres suivants

```
PrimaryServerAddress=172.16.78.251
SecondaryServerAddress=10.45.6.3
TertiaryServerAddress=10.45.6.2
```

- Menu Démarrer > Edit Acrylic Hosts File > Ajouter la ligne suivante à la fin du fichier

```
192.168.1.100 *.app
```

## Rappel des commandes Vagrant

- Lancer la VM

```bash
vagrant up
```

- Arrêter la VM
```bash
vagrant halt
```

- Redémarrer la VM
```bash
vagrant reload
```

- Provisionner la VM
```bash
vagrant provision
```

## Synchronisation des fichiers du projet via NFS

Si vous n'avez pas besoin du support des notifications de fichier [inotify](https://fr.wikipedia.org/wiki/Inotify) 
(ex: Compilation sur changement de fichiers via nodeJS), il est possible d'utiliser un point de montage NFS via le 
plugin `vagrant-winnfsd`.

Pour ce faire, il faut paramétrer la section `synced_folder` dans le fichier `config.yaml` comme décrit dans la 
section **Paramétrage**.

```yml
synced_folders:
  patbiodiv: # clé (nom du projet par exemple)
    source: "../AFB/PATBiodiv/www" # dossier relatif sur la machine hôte
    target: "/home/ubuntu/workspace/AFB/PATBiodiv" # dossier mappé sur la vm
  frr:
    source: "D:\\Projets\\FRR\\www" # dossier absolu sur la machine hôte ATTENTION à doubler les antislash
    target: "/home/ubuntu/workspace/FRR" # dossier mappé sur la vm
```

Lorsque la section `synced_folders` est renseignée dans le fichier de configuration, Vagrant va automatiquement 
lancer winnfsd pour monter les dossiers spécifiés via NFS.

Pour supporter les liens symboliques, `winnsfd.exe` doit s'exécuter en tant qu'Administrateur. 

- Ouvrir le dossier `%USERPROFILE%\.vagrant.d\gems\2.3.4\gems\vagrant-winnfsd-1.3.1\bin` (**/!\\** Adapter les versions)
- Selectionner `winnfsd.exe` > Bouton droit > Propriétés
- Activer l'onglet "Compatibilité", Cocher la case "Executer ce programme en tant qu'administrateur", Cliquer sur Appliquer

## Synchronisation des fichiers du projet via Unison

Si vous avez besoin du support des notifications de fichier [inotify](https://fr.wikipedia.org/wiki/Inotify) (ex: Compilation sur changement de fichiers 
via nodeJS), il est possible d'utiliser une synchronisation Unison à la place d'un point de montage NFS.

### Installation du client unison sur le poste de travail

- Copier les fichiers présents dans `unison/bin` dans le dossier `C:\bin`

- Ajouter le dossier `C:\bin` dans la variable d'environnement `PATH`

### Configuration d'un container unison dans un projet docker-compose

- Ajouter un service unison dans `docker-compose.override.dev.yml` et son volume de metadata associé (à adapter selon 
le besoin, le port doit être différent selon chaque projet).

```yml
services:
  web:
    ...
  unison:
    image: toilal/unison:2.48.4
    environment:
      - VOLUME=/var/www/html
      - OWNER_UID=1000
      - GROUP_ID=1000
      - UNISONLOCALHOSTNAME=nom-du-projet
    ports:
      - "4250:5000"
    volumes:
      - ".:/var/www/html"
      - "unison-volume:/.unison"
volumes:
  unison-volume: ~
```

Cette [image est un fork](https://github.com/Toilal/docker-image-unison) de l'image issue de 
[docker-sync.io](http://docker-sync.io/), qui ajoute la possibilité de définir la variable `GROUP_ID` et conserve
les métadonnées de unison au sein d'un volume.

Pour plus d'informations sur la configuration de ce container, se référer à la 
[documentation de l'image](https://github.com/Toilal/docker-image-unison).

- Monter le volume du container unison dans les containers nécessitant l'accès à ce dossier partagé.

```yml
services:
  web:
    environment:
      - VIRTUAL_HOST=eqo.app
    volumes_from:
      - unison
  unison:
    ...
```

- Placer le batch `docker-sync.bat` du dossier unison à la racine du projet pour lancer facilement la synchronisation
unison (à adapter selon le besoin, le port doit correspondre à celui défini dans `docker-compose.yml`).

### Avertissements et conseils d'utilisation

- Les méta-données git sont exclues de la synchronisation (dossier `.git`). Pour éviter tout problème, il est
préferable d'utiliser git à partir du poste de développement uniquement.

- Lors de la mise en place d'un projet existant sur un nouveau poste, il est cependant nécessaire d'effectuer la
commande `git clone` sur la VM (pour lancer les containers docker), puis sur le poste de développement
(pour obtenir le docker-sync.bat et activer la synchronisation de fichiers).
