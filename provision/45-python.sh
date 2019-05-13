#!/usr/bin/env bash

curl https://pyenv.run | bash

export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

export PATH="/home/vagrant/.pyenv/bin:$PATH">>"$HOME/.bashrc"
eval "$(pyenv init -)">>"$HOME/.bashrc"
eval "$(pyenv virtualenv-init -)">>"$HOME/.bashrc"

git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

pyenv latest install
pyenv latest install 2