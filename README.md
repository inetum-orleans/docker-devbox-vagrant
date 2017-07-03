# Docker sous Vagrant

## Pourquoi ?

Docker for windows pose des problèmes sur les dossiers montés dans le container:

- Performance médiocres.
- Droits altérés et difficile à maitriser.
- Liens symboliques absents, rendant l'utilisation de certains container impossibles.

Il faut donc un moyen de s'affranchir du partage de fichier hôte <-> VM.

## Solution

- VM Docker (Ubuntu Xenial).
- Vagrant pour provisionner Docker, Docker Compose et [nginx-proxy](https://github.com/jwilder/nginx-proxy).
- [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) pour synchroniser les fichiers entre l'hôte sous windows et la VM Docker.
- [Smartcd](https://github.com/cxreg/smartcd) (Activation/Désactivation automatique d'alias lors de l'entrée/sortie dans un dossier)

Cette solution est construite de zéro ce qui nous permet de garder un grand contrôle sur l'environnement technique.

*Note: nginx-proxy permet d'accéder un à container web via `http://monappli.app` plutôt que `http://192.168.1.100:<port>`*

## Pré-requis

- [Vagrant](https://www.vagrantup.com/).
- [Acrylic](https://sourceforge.net/projects/acrylic) (Optionnel, ([Aide d'installation sur StackOverflow](https://stackoverflow.com/questions/138162/wildcards-in-a-windows-hosts-file#answer-9695861), Proxy DNS local pour rediriger `*.app` vers 
l'environnement docker, identique au fichier /etc/host mais supporte les wildcard `*`)

## Attention aux sauts de ligne des fichiers texte

Pour éviter tout problème lors du partage de fichier entre Linux et Windows, il faut prendre quelques précautions au 
sujet des caractères de saut de lignes.

- Paramétrer l'option pour git `core.autocrlf false`.

```bash
# Dans le dossier racine de git
git config core.autocrlf false
```

- Paramétrer l'éditeur de code pour utiliser les sauts de ligne linux uniquement (LF).

## Installation

- Cloner le repository

```bash
git clone http://gitlab/PoleDigital/vagrant-docker.git
cd vagrant-docker
```

- Lancer un vagrant:

```bash
vagrant up
```

Au premier lancement, la box `ubuntu/xenial` est téléchargée depuis le cloud Vagrant, puis provisionnée selon la 
définition du Vagrantfile. Le vagrantfile provisionne grâce aux scripts présents dans le dossier `provision`.

Une fois la machine provisionnée, vous pouvez vous connecter à celle-ci via la commande :

```bash
vagrant ssh
```

Les commandes `docker` et `docker-compose` sont disponibles dans cet environnement.

## Paramétrage

Il est possible de paramétrer la VM avec le fichier `config.yaml`. Copier le fichier `config.example.yaml` vers 
`config.yaml`, et modifier selon vos besoins.

## Commandes Vagrant

Lancement de la vm

```bash
vagrant up
```

Extinction de la vm
```bash
vagrant halt
```

Redémarrage de la vm
```bash
vagrant reload
```

Re-provisionner de la vm
```bash
vagrant reload --provision
```

## Synchronysation des fichiers d'un projet docker-composer via Unison

### Installation du client unison sur le poste de travail

- Copier les fichiers présents dans `unison/bin` dans le dossier `C:/bin`

- Ajouter le dossier `C:/bin` dans la variable d'environnement `PATH`

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
