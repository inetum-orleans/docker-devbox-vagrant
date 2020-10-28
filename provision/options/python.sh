#!/usr/bin/env bash

if [[ ! -d "$HOME/.pyenv" ]]; then
  curl https://pyenv.run | bash
  
  export PATH="/home/vagrant/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  cat <<'EOF' >> "$HOME/.bashrc"
  
# Pyenv configuration
export PATH="/home/vagrant/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
  
  git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
  
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
  
  pyenv latest install -s
  pyenv latest local
  
  pip install pipenv virtualenv
else
  export PATH="/home/vagrant/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  pyenv update

  pyenv latest install -s
  pyenv latest local

  pip install pipenv virtualenv
fi

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
poetry completions bash | sudo tee "/etc/bash_completion.d/poetry.bash-completion">/dev/null

mkdir -p "$HOME/.config/fish/completions"
poetry completions fish | sudo tee "$HOME/.config/fish/completions/poetry.fish">/dev/null

mkdir -p "$HOME/.zfunc"
poetry completions zsh | sudo tee "$HOME/.zfunc/_poetry">/dev/null
#TODO: For zsh, you must then add the following line in your ~/.zshrc before compinit: