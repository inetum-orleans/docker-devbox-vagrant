#!/usr/bin/env bash

if [ ! -d $HOME/.pyenv ]; then
  curl https://pyenv.run | bash

  cat << EOF >> "$HOME/.bashrc"
  
# Pyenv configuration
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF

  echo export PATH="/home/vagrant/.pyenv/bin:$PATH">>"$HOME/.bashrc"
  echo 'eval "$(pyenv init -)"'>>"$HOME/.bashrc"
  echo 'eval "$(pyenv virtualenv-init -)"'>>"$HOME/.bashrc"
  
  git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
  
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
  
  pyenv latest install -s
  pyenv latest install 2 -s
  pyenv latest global
  
  pip install pipenv virtualenv
else
  pyenv update

  pyenv latest install -s
  pyenv latest install 2 -s
  pyenv latest global

  pip install pipenv virtualenv
fi