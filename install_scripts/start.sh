# /bin/bash -xe

groupmod -g ${HOST_GID} tux
usermod -u ${HOST_UID} -g ${HOST_GID} tux

apachectl configtest

/etc/init.d/php${PHP_VERSION}-fpm start

apachectl -D FOREGROUND
