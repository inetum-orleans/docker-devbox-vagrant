#!/bin/bash
NGINX_PROXY_HOME="${HOME}/.nginx-proxy"

if [ ! "$(docker ps -a | grep nginx-proxy)" ]; then
    echo "## Création du container nginx-proxy"

    if [ ! "$(docker network list | grep nginx-proxy)" ]; then
        echo "## Création du network nginx-proxy"
        docker network create nginx-proxy
    else
        echo "## Le network nginx-proxy existe déja"
    fi

    # Ce dossier permet de personnaliser la configuration de chaque virtualhost
    # Voir documentation https://github.com/jwilder/nginx-proxy#custom-nginx-configuration
    mkdir -p "${NGINX_PROXY_HOME}/vhost.d"
    mkdir -p "${NGINX_PROXY_HOME}/certs"

    # Le téléchargement de certains gros fichiers échoue parfois sans ces paramètres
    echo "proxy_buffer_size          128k;">"${NGINX_PROXY_HOME}/my_proxy.conf"
    echo "proxy_buffers              4 256k;">>"${NGINX_PROXY_HOME}/my_proxy.conf"
    echo "proxy_busy_buffers_size    256k;">>"${NGINX_PROXY_HOME}/my_proxy.conf"

    cat > "${NGINX_PROXY_HOME}/certs/nginx-proxy-genssl.sh" <<EOF
#!/bin/bash

# Génération d'un script de création de certifications SSL
cd "${NGINX_PROXY_HOME}/certs"
openssl req \
    -nodes -new -x509 -days 3650 \
    -keyout "\$1.key" \
    -subj "/C=FR/O=GFI Informatique/CN=\$1" \
    -extensions SAN \
    -reqexts SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf "\n[SAN]\nsubjectAltName=DNS:\$1")) \
    -out "\$1.crt"
EOF
    chmod +x "${NGINX_PROXY_HOME}/certs/nginx-proxy-genssl.sh"

    docker run -d -p 80:80 -p 443:443 -e "HTTPS_METHOD=noredirect" \
      --restart unless-stopped --net nginx-proxy --name nginx-proxy \
      -v "${NGINX_PROXY_HOME}/certs:/etc/nginx/certs" \
      -v "${NGINX_PROXY_HOME}/my_proxy.conf:/etc/nginx/conf.d/my_proxy.conf:ro" \
      -v "${NGINX_PROXY_HOME}/vhost.d:/etc/nginx/vhost.d:ro" \
      -v /var/run/docker.sock:/tmp/docker.sock:ro \
      jwilder/nginx-proxy
else
    echo "## Le container nginx-proxy existe déja."
fi
