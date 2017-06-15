# ENV VARS + PROXY GFI
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games' > /etc/environment
echo 'http_proxy=http://webdefence.global.blackspider.com:80' >> /etc/environment
echo 'https_proxy=http://webdefence.global.blackspider.com:80' >> /etc/environment
echo 'no_proxy=localhost,127.0.0.1,192.168.99.100,frordvmf002,gitlab,glbaso01.asogfi.fr' >> /etc/environment
echo 'HTTP_PROXY=http://webdefence.global.blackspider.com:80' >> /etc/environment
echo 'HTTPS_PROXY=http://webdefence.global.blackspider.com:80' >> /etc/environment
echo 'NO_PROXY=localhost,127.0.0.1,192.168.99.100,frordvmf002,gitlab,glbaso01.asogfi.fr' >> /etc/environment

#unison
sudo apt-get install -y unison

# INSTALL DOCKER
sudo apt-get update

sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get -y install docker-ce

# PROXY FOR DOCKER
sudo mkdir -p /etc/systemd/system/docker.service.d

touch /etc/systemd/system/docker.service.d/http-proxy.conf
sudo chown ubuntu:ubuntu /etc/systemd/system/docker.service.d/http-proxy.conf
echo '[Service]' > /etc/systemd/system/docker.service.d/http-proxy.conf
echo 'Environment="HTTP_PROXY=http://webdefence.global.blackspider.com:80" "HTTPS_PROXY=http://webdefence.global.blackspider.com:80" "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com,192.168.99.100,frordvmf002,gitlab,glbaso01.asogfi.fr"' >> /etc/systemd/system/docker.service.d/http-proxy.conf

sudo systemctl daemon-reload

sudo systemctl restart docker

# systemctl show --property=Environment docker

# GROUP FOR DOCKER
sudo groupadd docker
sudo usermod -aG docker $USER
exec sudo su -l $USER

# CONFIGURE AND ENABLE DOCKER
sudo systemctl enable docker

#DOCKER COMPOSE
# dockerComposeVersion=1.13.0
curl -L https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m` > ./usr/local/bin/docker-compose
sudo mv docker-compose /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

# docker-compose --version

# NGINX PROXY
docker network create nginx-proxy
docker run -d -p 80:80 --restart unless-stopped --net nginx-proxy -v /var/run/docker.sock:/tmp/docker.sock:ro --name nginx-proxy jwilder/nginx-proxy
