#!/usr/bin/env bash
echo "## Configuration globale DDB"
  cat <<EOF > "${HOME}/.docker-devbox/ddb.yaml"
# =======================================================================
# Fichier généré par gfi-centre-ouest/docker-devbox-vagrant le $(date +"%d/%m/%Y")
#                     Ne pas modifier ce fichier
#          Pour surcharger, créez un fichier ddb.local.yaml
# =======================================================================
docker:
  debug:
    host: ${HOST_IP}
shell:
  aliases:
    dc: docker-compose
EOF
