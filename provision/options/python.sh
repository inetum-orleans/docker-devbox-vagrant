#!/usr/bin/env bash

if [[ ! -d "$HOME/.pyenv" ]]; then
  curl https://pyenv.run | bash
  
  export PATH="/home/vagrant/.pyenv/bin:/home/vagrant/.local/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  cat <<'EOF' >> "$HOME/.bashrc"
  
# Pyenv configuration
export PATH="/home/vagrant/.pyenv/bin:/home/vagrant/.local/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
  
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev git
  
  pyenv install 3.11 -s
  pyenv shell 3.11
  
  pip install pipenv virtualenv
else
  export PATH="/home/vagrant/.pyenv/bin:/home/vagrant/.local/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"

  pyenv update

  pyenv install 3.11 -s
  pyenv shell 3.11

  pip install pipenv virtualenv
fi

curl -sSL https://install.python-poetry.org/ | python
poetry completions bash | sudo tee "/etc/bash_completion.d/poetry.bash-completion">/dev/null

mkdir -p "$HOME/.config/fish/completions"
poetry completions fish | sudo tee "$HOME/.config/fish/completions/poetry.fish">/dev/null

mkdir -p "$HOME/.zfunc"
poetry completions zsh | sudo tee "$HOME/.zfunc/_poetry">/dev/null
#TODO: For zsh, you must then add the following line in your ~/.zshrc before compinit: