#!/usr/bin/env bash
echo "## Configuration globale DDB"
cat <<EOF > "${HOME}/.docker-devbox/ddb.yaml"
# =======================================================================
# Generated file by gfi-centre-ouest/docker-devbox-vagrant on $(date +"%Y/%m/%d")
# Do not modify. To override, create a ddb.local.yaml file.
# =======================================================================
docker:
  debug:
    host: ${HOST_IP}
EOF
