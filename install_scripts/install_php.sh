#!/bin/bash -xe

# Mise à jour du systeme
apt update && apt upgrade -y

# Mise à jour des dépendances pour PHP
apt install -y wget ca-certificates apt-transport-https dialog apt-utils sudo php-redis curl zip unzip vim curl telnet &&
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&
  echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list &&
  apt update

# Installation de PHP
apt install -y php"${PHP_VERSION}"

apt install -y \
  php"${PHP_VERSION}"-apcu \
  php"${PHP_VERSION}"-amqp \
  php"${PHP_VERSION}"-bcmath \
  php"${PHP_VERSION}"-cgi \
  php"${PHP_VERSION}"-curl \
  php"${PHP_VERSION}"-dev \
  php"${PHP_VERSION}"-fpm \
  php"${PHP_VERSION}"-gd \
  php"${PHP_VERSION}"-imap \
  php"${PHP_VERSION}"-intl \
  php"${PHP_VERSION}"-mbstring \
  php"${PHP_VERSION}"-mysql \
  php"${PHP_VERSION}"-mcrypt \
  php"${PHP_VERSION}"-pdo \
  php"${PHP_VERSION}"-pgsql \
  php"${PHP_VERSION}"-soap \
  php"${PHP_VERSION}"-xml \
  php"${PHP_VERSION}"-xmlrpc \
  php"${PHP_VERSION}"-xsl \
  php"${PHP_VERSION}"-zip

apt install -y php-pear git libgeoip-dev

## Installing geoip pecl tool
pecl install geoip-beta
bash -c "echo extension=geoip.so > /etc/php/${PHP_VERSION}/fpm/conf.d/geoip.ini"

apt install -y git

pecl install xdebug

IFS=,
zones=fpm,cli,cgi,apache2

for zone in $zones ; do
    cat >> /etc/php/${PHP_VERSION}/${zone}/conf.d/20-xdebug.ini <<EOT
    zend_extension=xdebug.so;
    xdebug.remote_enable=1;
    xdebug.remote_mode=req;
    xdebug.remote_port=9000;
    xdebug.remote_host=127.0.0.1;
    xdebug.remote_connect_back=0;
EOT

done

if [ "${WITH_SYMFONY}" != 0 ]; then
  wget https://get.symfony.com/cli/installer -O - | bash
  mv /root/.symfony/bin/symfony /usr/local/bin/symfony
fi

a2enmod php"${PHP_VERSION}"

# Installing composer
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
  echo >&2 'ERROR: Invalid installer checksum'
  rm composer-setup.php
  exit 1
fi

php composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
RESULT=$?

if [ "$RESULT" != 0 ]; then
  echo >&2 'Erro when installing composer'
  exit $RESULT
fi

rm composer-setup.php
