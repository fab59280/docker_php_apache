# /bin/bash -xe

groupadd -g ${HOST_UID} tux

useradd -m  -u ${HOST_UID} -g ${HOST_GID} -s /bin/bash tux

apt install -y sudo

usermod -aG sudo tux

# set default passwd to tux user
tuxpasswd="azertyuiop"
echo "tux:${tuxpasswd}" | chpasswd

echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

cat >> /home/tux/.bashrc <<EOT
alias ls='ls --color=auto';
alias ll='ls --color=auto -alF';
alias la='ls --color=auto -A';
alias l='ls --color=auto -CF';
EOT
