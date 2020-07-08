# /bin/bash -xe

# Mise à jour du systeme
apt update && apt upgrade -y

# Mise à jour des dépendances pour PHP
apt install -y wget ca-certificates apt-transport-https dialog apt-utils sudo php-redis curl zip unzip vim curl telnet && \
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list && \
apt update

# Installation de PHP
apt install -y php${PHP_VERSION}

apt install -y \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-amqp \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cgi \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip

apt install -y php-pear git

pecl install xdebug apcu

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

wget https://get.symfony.com/cli/installer -O - | bash
mv /root/.symfony/bin/symfony /usr/local/bin/symfony

a2enmod php${PHP_VERSION}


# Installing composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
php -r "unlink('composer-setup.php');"
