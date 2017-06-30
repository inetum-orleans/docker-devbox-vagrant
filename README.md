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
- Unison pour synchroniser les fichiers entre l'hôte sous windows et la VM Docker.

Cette solution est construite de zéro ce qui nous permet de garder un grand contrôle sur l'environnement technique.

*Note: nginx-proxy permet d'accéder un à container web via `http://monappli.app` plutôt que `http://192.168.1.100:<port>`*

## Pré-requis

- [Vagrant](https://www.vagrantup.com/).
- plugin [vagrant-reload](https://github.com/aidanns/vagrant-reload).

```bash
vagrant plugin install vagrant-reload
```

## Installation

- Cloner le repository

```bash
git clone http://frordvmf002/PoleDigital/vagrant-docker.git
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

- Ajouter un service unison dans `docker-compose.yml`.

```yml
services:
  unison:
    image: toilal/unison:2.48.4
    environment:
      - VOLUME=/var/www/html
      - OWNER_UID=1000
      - GROUP_ID=1000
    ports:
      - "4250:5000"
    volumes:
      - ".:/var/www/html"
```

Cette [image est un fork](https://github.com/Toilal/docker-image-unison) de l'image issue de 
[docker-sync.io](http://docker-sync.io/), qui ajoute la possibilité de définir la variable `GROUP_ID`.

Pour plus d'informations sur la configuration de ce container, se référer à la 
[documentation de l'image](https://github.com/Toilal/docker-image-unison).

- Monter les volumes de ce service dans les containers nécessitant l'accès à ce dossier partagé.