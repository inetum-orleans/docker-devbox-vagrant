# Docker Devbox

Docker devbox est un projet Vagrant intégrant tout le nécessaire pour créer des environments de développement Docker
sous Windows & Mac.

## Pourquoi ?

Docker for windows et Docker toolbox utilisent des partages VirtualBox/Hyper-V entre l'hôte Windows et la VM Linux ou
s'execute le daemon docker pour monter le volumes locaux dans le container. Celà entraine une série de problèmes:

- Performance médiocres.
- Droits altérés et difficiles à maitriser.
- Liens symboliques absents provoquant des problèmes pour certains programmes.

## Solution

- Machine virtuelle VirtualBox (Ubuntu).
- Vagrant pour provisionner votre machine virtuelle, notamment avec Docker et Docker Compose.
- Traefik : solution de reverse proxy pour la prise en charge de DNS locaux pour l'accès à vos projets web.
- Mutagen pour synchoniser vos fichiers entre votre workspace Windows et votre machine virtuelle.
- CloudFlareSSL : solution de génération de certificat SSL.
- Portainer : solution de management Docker de vos images, containers, volumes, network, ...
- [Smartcd](https://github.com/cxreg/smartcd) (Activation/Désactivation automatique d'alias lors de l'entrée/sortie dans un dossier).

## Pré-requis
- Windows > 10
- RAM 16 Go minimum
- SSD 60 Go libres
- Privilèges d'administration pour installer VirtualBox, Vagrant, Acrylic (ou modifier le fichier hosts), node.js et git for Windows
- L'autorisation des liens symboliques dans Windows (voir la [documentation d'installation](docs/installation_guides/Install.fr.md), étape 2)

## Guides d'installation

[Guide d'installation étapes par étapes](docs/installation_guides/Install.fr.md)