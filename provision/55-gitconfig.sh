#!/usr/bin/env bash

cat << EOF > "$HOME/.gitignore-global"
*.iml
.idea/
EOF

git config --global credential.helper store
git config --global core.excludesfile "$HOME/.gitignore-global"
git config --global pull.rebase true