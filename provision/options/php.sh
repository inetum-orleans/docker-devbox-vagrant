if [[ ! -d "$HOME/.phpenv" ]]; then
  curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \  | bash

  # PHPEnv configuration
  export PHPENV_ROOT="/home/vagrant/.phpenv"
  export PATH="$HOME/.phpenv/bin:${PATH}"
  eval "$(phpenv init -)"

  git clone https://github.com/momo-lab/xxenv-latest.git "$(phpenv root)"/plugins/xxenv-latest

  cat <<'EOF' >>"$HOME/.bashrc"
# PHPEnv configuration
export PHPENV_ROOT="/home/vagrant/.phpenv"
export PATH="$HOME/.phpenv/bin:${PATH}"
eval "$(phpenv init -)"
EOF

  sudo apt-get install -y autoconf dpkg-dev file g++ gcc libc-dev make pkg-config re2c \
    libxml2-dev libcurl4-openssl-dev libjpeg-dev libtidy-dev libxslt1-dev libzip-dev unzip

  # Some module may require additional libs, like libpq-dev for pdo_pgsql, ...

  phpenv latest install -s
  phpenv latest global
else
  export PHPENV_ROOT="/home/vagrant/.phpenv"
  export PATH="$HOME/.phpenv/bin:${PATH}"
  eval "$(phpenv init -)"

  phpenv update
fi
