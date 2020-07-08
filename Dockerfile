FROM debian:9

MAINTAINER Fabien Manier

ARG PHP_VERSION=7.1
ARG HOST_UID=1000
ARG HOST_GID=1000

ENV HOST_UID=${HOST_UID}
ENV HOST_GID=${HOST_GID}
ENV PHP_VERSION=${PHP_VERSION}

COPY install_scripts/install_server.sh /install.sh
RUN chmod 700 install.sh && ./install.sh && rm -rf install.sh

COPY install_scripts/install_php.sh /install.sh
RUN chmod 700 install.sh && ./install.sh && rm -rf install.sh

COPY install_scripts/install_user.sh /install.sh
RUN chmod 700 install.sh && ./install.sh && rm -rf install.sh

COPY install_scripts/start.sh /start.sh
RUN chmod 700 /start.sh

EXPOSE 80

ENTRYPOINT ["sh", "-c", "/start.sh"]
