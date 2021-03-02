#!/bin/bash -xe

if [ "${NODE_VERSION}" == 0 ]; then
    exit 0;
fi
# Mise à jour du systeme
apt update && apt upgrade -y

curl -sL https://deb.nodesource.com/setup_"${NODE_VERSION}".x | sudo bash

sudo apt -y install gcc \
                    g++ \
                    make \
                    nodejs

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
