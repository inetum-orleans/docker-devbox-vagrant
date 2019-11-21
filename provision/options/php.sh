if [[ ! -d "$HOME/.phpenv" ]]; then
  curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer \  | bash

  # PHPEnv configuration
  export PHPENV_ROOT="$HOME/.phpenv"
  export PATH="$HOME/.phpenv/bin:${PATH}"
  eval "$(phpenv init -)"

  git clone https://github.com/momo-lab/xxenv-latest.git "$(phpenv root)"/plugins/xxenv-latest

  cat <<'EOF' >>"$HOME/.bashrc"
# PHPEnv configuration
export PHPENV_ROOT="$HOME/.phpenv"
export PATH="$HOME/.phpenv/bin:${PATH}"
eval "$(phpenv init -)"
EOF

  sudo apt-get install -y autoconf dpkg-dev file g++ gcc libc-dev make pkg-config re2c \
    libxml2-dev libcurl4-openssl-dev libjpeg-dev libtidy-dev libxslt1-dev libzip-dev \
    libssl-dev libmcrypt-dev libcurl3 libpq-dev libmysqlclient-dev unzip

  # Compile openssl-1.0 and curl from sources and export the following environment variables before compiling PHP 5.
  # PHP_BUILD_CONFIGURE_OPTS="--with-openssl-dir=/usr/local/openssl-1.0 --with-curl=/usr/local/curl-with-openssl-1.0"
  # PKG_CONFIG_PATH="/usr/local/openssl-1.0/lib/pkgconfig:/usr/local/curl-with-openssl-1.0/lib/pkgconfig"
  sudo curl -o /opt/openssl-1.0.2t.tar.gz https://www.openssl.org/source/openssl-1.0.2t.tar.gz
  sudo tar zxvf /opt/openssl-1.0.2t.tar.gz -C /opt
  sudo ln -s /opt/openssl-1.0.2t /opt/openssl-1.0
  (cd /opt/openssl-1.0 && sudo ./config shared --prefix=/usr/local/openssl-1.0 --openssldir=/usr/local/openssl-1.0 && sudo make && sudo make install)

  sudo curl -o /opt/curl-7.67.0.tar.gz https://curl.haxx.se/download/curl-7.67.0.tar.gz
  sudo tar zxvf  /opt/curl-7.67.0.tar.gz -C /opt
  sudo chown -R root:root curl-7.67.0
  sudo ln -s /opt/curl-7.67.0 /opt/curl
  (cd /opt/curl && sudo ./configure --with-ssl=/usr/local/openssl-1.0 --prefix=/usr/local/curl-with-openssl-1.0 && sudo make && sudo make install)

  phpenv latest install -s
  phpenv latest global
  composer global require hirak/prestissimo
else
  export PHPENV_ROOT="$HOME/.phpenv"
  export PATH="$HOME/.phpenv/bin:${PATH}"
  eval "$(phpenv init -)"

  phpenv update
fi
