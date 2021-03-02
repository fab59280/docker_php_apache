#!/bin/bash -xe

apachectl configtest

/etc/init.d/php"${PHP_VERSION}"-fpm start

apachectl -D FOREGROUND
