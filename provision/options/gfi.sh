#!/usr/bin/env bash
echo "## Configuration locale DDB (GFI)"
cat <<EOF > "${HOME}/.docker-devbox/ddb.local.yaml"
certs:
  cfssl:
    server:
      host: inetum-cfssl.azurewebsites.net
      port: 443
      ssl: true
      verify_cert: true
shell:
  aliases:
    dc: docker compose
  global_aliases:
    - dc
EOF
