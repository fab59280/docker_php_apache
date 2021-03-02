#!/bin/bash -xe

# Mise à jour du systeme
apt update && apt upgrade -y

# Installation du serveur
apt install -y apache2

a2enmod proxy_fcgi setenvif rewrite mime expires env proxy proxy_balancer proxy_http setenvif headers

a2enconf php"${PHP_VERSION}"-fpm # Again, this depends on your PHP vendor.
a2dismod php"${PHP_VERSION}" # This disables mod_php.
a2dismod mpm_prefork # This disables the prefork MPM. Only one MPM can run at a time.
a2enmod mpm_event # Enable event MPM. You could also enable mpm_worker.

a2enmod ssl http2

apachectl configtest

