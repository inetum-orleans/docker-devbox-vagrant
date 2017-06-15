# Docker sous Vagrant
## Pourquoi ?
Les problèmes de droits avec Docker for windows, de performances entre hôte et VM que ce soit sous VMWare ou Virtualbox ... que dire d'autre ? Il fallait un moyen de s'affranchir du partage de fichier hôte <-> VM.
## Solution
Une VM Ubuntu Xenial, provisionné via vagrant et du shell qui contient l'environnement Docker complet et dont le partage de fichier est assuré par un plugin tiers : ici `winnfsd`.
## Pré-requis
Il faut au préalable avoir installé  Vagrant voir ce [lien](https://www.vagrantup.com/) et installé le plugin winnfd via la commande :
```bash
vagrant plugin install vagrant-winnfsd
```
Voici un lien vers la documentation du plugin au cas où [ici](https://github.com/winnfsd/vagrant-winnfsd)
## Première Utilisation
Il suffit de cloner le repo :
```bash
git clone http://frordvmf002/PoleDigital/vagrant-docker.git chemin/souhaite
```
et de lancer un vagrant up :
```bash
vagrant up
```
La machine va être téléchargée depuis le cloud Vagrant (hashicorp) et le provisioning sera assuré par la `vargantfile` et le script `provision.sh`.

Une fois la machine provisionnée, vous pouvez vous connecter à celle-ci via la commande :
```bash
vagrant ssh
```
## Paramétrage
POur travailler, il vous faudra créer un fichier `shared.yaml` qui renseigne les dossier partagés entre l'hôte et la VM. Pour ce faire, il vous suffit de copier le fichier `shared.examples.yaml` et de le modifier selon vos besoins.
## Informations
le network et le container nginx-proxy est assuré par le provisionning, vous pourrez y faire référence dans vos fichiers docker-compose.yml.
