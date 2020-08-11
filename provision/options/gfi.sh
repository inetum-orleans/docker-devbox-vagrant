#!/usr/bin/env bash
echo "## Configuration globale DDB (GFI)"
cat <<EOF > "${HOME}/.docker-devbox/ddb.yaml"
# =======================================================================
# Generated file by gfi-centre-ouest/docker-devbox-vagrant on $(date +"%Y/%m/%d")
# Do not modify. To override, create a ddb.local.yaml file.
# =======================================================================
docker:
  debug:
    host: ${HOST_IP}
certs:
  cfssl:
    server:
      host: cfssl.etudes.local
      port: 443
      ssl: true
      verify_cert: true
shell:
  aliases:
    dc: docker-compose
EOF
