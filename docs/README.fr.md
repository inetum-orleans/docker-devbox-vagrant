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

- Machine vitruelle Oracle (Ubuntu).
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

## Installation étape par étape

### Etape 1 : Organiser les répertoires de travail
- Privilégiez les disques SSD pour plus de de performances
- Créez les répertoires de la manière suivante, **pensez à changer les chemins si ```c:\``` n'est pas votre volume cible** :

```
c:\workspace
c:\workspace\projects
```

### Etape 2 : Ajouter une permission de créer des liens symboliques

- Ouvrir l'application Stratégie de sécurité locale **en tant qu'administrateur** : 
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools
- Ajouter dans ```Stratégies locale > Attribution des droits utilisateur > Créer des liens symboliques``` le groupe utilisateur ```Utilisateurs authentifiés``` comme ci-dessous

![strat_secu_local.png](captures/strat_secu_local.png)

### Etape 3 : Installer Virtualbox

- Installer la dernière version stable pour Windows de Virtualbox : `winget install Virtualbox` (dans une console ouverte en mode administrateur)
- Redémarrer le poste

### Etape 4 : Installer Vagrant

- Installer la dernière version stable pour Windows de Vagrant : `winget install Vagrant` (dans une console ouverte en mode administrateur)
- Ouvrez un autre terminal pour lancer les commandes suivantes (sinon, vagrant n'est pas connu après la première install)
- Installer les plugins Vagrant suivants :
  - ```vagrant plugin install vagrant-certificates```
  - ```vagrant plugin install vagrant-disksize```

Dans le cas de cette erreur : `ERROR:  You must add /C=US/O=Starfield Technologies, Inc./OU=Starfield Class 2 Certification Authority to your local trusted store
Vagrant failed to load a configured plugin source.`: Utilisez la commande 
```
set SSL_CERT_FILE=C:\HashiCorp\Vagrant\embedded\cacert.pem
```
### Etape 5 : Installer Git for Windows

- Lancer la commande `winget install Git.Git` (dans une console ouverte en mode administrateur tant que le ticket : https://github.com/mutagen-io/mutagen/issues/491 n'est pas résolu)

### Etape 6 : Configurer Git

- Exécuter les commandes suivantes pour votre configuration globale Git, **dans un git bash**, pas forcément administrateur. Adaptez évidemment les noms...

```
git config --global --replace-all user.name "First Last"
git config --global --replace-all user.email "first.last@mail.com"
git config --global --replace-all pull.rebase true
git config --global --replace-all core.autocrlf false
git config --global --replace-all core.eol lf
git config --global --replace-all core.filemode false
git config --global --replace-all http.postBuffer 1000000000
git config --global --replace-all lfs.activitytimeout 60
git config --global --replace-all http.version HTTP/1.1
```
- Pour vérifier votre configuration Git globale : ```git config --list```

### Etape 7 : Installer Docker Devbox Vagrant

- Utiliser un terminal en étant placé dans ```c:\workspace```
- Cloner le repo github public du projet ```git clone https://github.com/gfi-centre-ouest/docker-devbox-vagrant docker-devbox```
- Se placer dans le répertoire ```docker-devbox```
- Copier-coller le fichier ```config.example.yaml``` en le renommant ```config.yaml``` et adapter les valeurs en fonction du besoin.
Dans `env` vont se trouver des variables utilisées dans les scripts shell de provision de votre VM.
Le tableau `provision_options` va servir à appeler des scripts supplémentaires présents dans `/provision/options`
```
env:
  AZ_USERNAME: username Azure
  AZ_PASSWORD: password Azure
  AZ_TENANT: tenant Azure
provision_options: ['mon-script']
```

### Etape 8 : Créer une clé SSH

Pour vérifier l'existence d'un clé SSH, il faut vérifier la présence dans le profil utilisateur d'un répertoire ```.ssh``` contenant 2 fichiers ```id_rsa (clé privée) et id_rsa.pub (clé publique)```, **si aucune clé existe il faut en créer une** :

- Créer une clé SSH en ouvrant git bash (ou équivalent) et en lançant la commande `ssh-keygen -t rsa`
- L'ajout d'un mot de passe à la clé SSH n'est pas nécessaire

### Etape 9 : Installer Mutagen

- Se placer dans le dossier ```c:\workspace```
- Créer un dossier ```c:\workspace\mutagen```
- Créer un dossier ```c:\workspace\mutagen\data```
- Télécharger Mutagen pour Windows x386 : https://github.com/mutagen-io/mutagen/releases/tag/v0.17.2
- Extraire le contenu de l'archive dans ```c:\workspace\mutagen```

### Etape 10 : Configurer les variables d'environnement

- Créer la variable d'environnement suivante :

```
MUTAGEN_DATA_DIRECTORY=c:\workspace\mutagen\data
```

- Modifier la variable d'environnement ```Path``` pour inclure le chemin vers l'exe Mutagen ```c:\workspace\mutagen```

### Etape 11 : Finaliser l'installation de Mutagen

- Exécuter les commandes suivantes

```
mutagen daemon start  # Start the daemon for this windows session
mutagen daemon register  # Start automatically on windows session startup
```

### Etape 12 : Provisionner la machine virtuelle

- Redémarrer votre poste
- Ouvrir un terminal en étant placé dans ```c:\workspace\docker-devbox```
- Lancer la commande suivante (en tant qu'administrateur si c'est la première fois) : ```vagrant up``` (l'exécution de cette commande peut prendre plusieurs minutes, donc patience)

### Etape 13 : Installer les scripts de lancement de ddb
Coming soon

### Etape 14 : Valider le bon fonctionnement

#### Valider la connexion SSH
- Ouvrir un terminal en étant placé dans ```c:\workspace\docker-devbox```
- Lancer une des commandes suivantes : ```vagrant ssh``` ou ```ssh vagrant@192.168.99.100``` (raccourci qui gagne 5-10 secondes à l'exécution)
- Autoriser la connexion si demandé

La commande vagrant SSH permet de se connecter en SSH dans votre machine virtuelle

![SSH_validate.png](captures/SSH_validate.png)

#### Valider la synchronisation Mutagen
- Créer le dossier suivant ```c:\workspace\projects\demo```
- Créer un fichier de test ```c:\workspace\projects\demo\test.txt```
- Lancer le script ```openWt.mjs``` qui lui même va exécuter ```mutagenStart.mjs```.

Une fois connecté à la machine, vérifier que Mutagen est bien lancé avec un Alpha et un Beta :
![mutagen_validate.png](captures/mutagen_validate.png)

- Si vous n'avez pas installé les scripts de lancement alors lancez la commande suivante dans un terminal : 

````
mutagen sync create C:\\workspace\\projects\\demo root@192.169.99.100:/home/vagrant/projects/demo --sync-mode two-way-resolved --default-file-mode-beta 664 --default-directory-mode-beta 775 --default-owner-beta vagrant --default-group-beta vagrant
````

Une fois connecté à la machine, vérifier que Mutagen est bien lancé en effectuant la commande :
`mutagen sync list`

- Vérifier que le fichier test.txt est bien présent sur votre VM avec la commande ```ls -al projects/demo```
![mutagen_validate_2.png](captures/mutagen_validate_2.png)

#### Valider le provisionning de votre VM
- Lancer la commande suivante : ```docker ps```

![provision_validate.png](captures/provision_validate.png)

### Etape 15 : Services disponibles dans votre machine virtuelle

La solution docker devbox met à disposition quelque soit le projet 3 services permettant de gérer certains aspects de tous vos projets :

- **Portainer** : solution de management Docker de vos images, containers, volumes, network, ...
- **Traefik** : solution de reverse proxy pour la prise en charge de DNS locaux pour l'accès à vos projets web
- **CloudFlareSSL** : solution de génération de certificat SSL

Cela se traduit par :

- 3 containers Docker toujours actifs sur votre machine virtuelle

![docker_containers.png](captures/docker_containers.png)

Afin d'accéder aux IHM de certains de ces services, il faut renseigner au sein du fichier de hosts de Windows les éléments suivants :

```
192.168.99.100 portainer.test
192.168.99.100 traefik.test
```

### Etape 16 : Installer et configurer Acrylic (optionnel)
Coming soon

### Etape 17 : Certificats SSL (optionnel)
Coming soon